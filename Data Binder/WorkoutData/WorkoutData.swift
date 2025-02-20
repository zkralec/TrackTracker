//
//  WorkoutData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/16/24.
//

import Foundation

// Workout data vars
struct WorkoutData: Codable, Hashable {
    var date: Date
    var meters: [Int]
    var times: [Int]
    var sets: Int
    var workoutDay: Bool
    var dayComplete: Bool
}

extension WorkoutData {
    // Function to clear all past workout data stored in UserDefaults
    static func clearAllData() {
        UserDefaults.standard.removeObject(forKey: "workoutData")
        UserDefaults.standard.removeObject(forKey: "currentDate")
        print("Cleared all past workout data.")
    }
    
    // Loads the user workout data
    static func loadData() -> WorkoutData? {
        if let data = UserDefaults.standard.data(forKey: "workoutData") {
            do {
                let decodedData = try JSONDecoder().decode(WorkoutData.self, from: data)
                print("Loaded workout data.")
                return decodedData
            } catch {
                print("Error decoding workout data: \(error)")
                return nil
            }
        }
        return nil
    }
    
    // Saves the user workout data to storage and updates past workout data
    func saveData() {
        // Check if the saved data is different from the current data or if it's a new day
        if let savedData = WorkoutData.loadData() {
            let isDifferent = savedData != self
            let isNewDay = !Calendar.current.isDate(savedData.date, inSameDayAs: self.date)
            
            if isDifferent || isNewDay {
                do {
                    // Remove the old workout data from the same day
                    var pastData = PastWorkoutData.loadPast()
                    pastData.removeWorkout(from: self.date)
                    
                    // Encode the current workout data
                    let data = try JSONEncoder().encode(self)
                    UserDefaults.standard.set(data, forKey: "workoutData")
                    print("Saved workout data: \(self)")
                    
                    // Update the list of past workout data
                    pastData.update(with: self)
                    pastData.savePast()
                    print("Updated past workout data!")
                } catch {
                    print("Error encoding or saving workout data: \(error.localizedDescription)")
                }
            } else {
                print("No changes in workout data. Not saving.")
            }
        } else {
            // If there's no saved data, save the current data
            do {
                let data = try JSONEncoder().encode(self)
                UserDefaults.standard.set(data, forKey: "workoutData")
                print("Saved workout data: \(self)")
            } catch {
                print("Error encoding or saving workout data: \(error.localizedDescription)")
            }
        }
    }
    
    // Resets workout data on new day
    static func updateDataAtStartOfDay(currentDate: Date) {
        let calendar = Calendar.current
        let storedDate = UserDefaults.standard.object(forKey: "currentDate") as? Date ?? Date.distantPast
        
        if !calendar.isDate(currentDate, inSameDayAs: storedDate) {
            // Reset workout data at new day
            UserDefaults.standard.set(currentDate, forKey: "currentDate")
            let defaultWorkoutData = WorkoutData(date: currentDate,
                                                 meters: [],
                                                 times: [],
                                                 sets: 0,
                                                 workoutDay: true,
                                                 dayComplete: false)
            defaultWorkoutData.saveData()
            print("New day. Resetting workout data.")
        }
    }
}
