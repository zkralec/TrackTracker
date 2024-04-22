//
//  WorkoutData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/16/24.
//

import Foundation

// Workout data vars
struct WorkoutData: Codable {
    var date: Date
    var meters: [Int]
    var reps: Int
    var blocks: Bool
    var recovery: Bool
    var grass: Bool
    var hills: Bool
    var isDayComplete: Bool
}

extension WorkoutData {
    // Loads the user workout data
    func loadData() -> WorkoutData? {
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
    
    // Saves the user workout data to storage
    func saveData() {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: "workoutData")
            print("Saved workout data: \(self)")
        } catch {
            print("Error encoding workout data: \(error.localizedDescription)")
        }
    }
    
    // Resets workout data on new day
    static func updateDataAtStartOfDay(currentDate: Date) {
        let calendar = Calendar.current
        let storedDate = UserDefaults.standard.object(forKey: "currentDate") as? Date ?? Date.distantPast
        
        if !calendar.isDate(currentDate, inSameDayAs: storedDate) {
            //Reset workout data at new day
            UserDefaults.standard.set(currentDate, forKey: "currentDate")
            let defaultWorkoutData = WorkoutData(date: currentDate, meters: [], reps: 0, blocks: false, recovery: false, grass: false, hills: false, isDayComplete: false)
            defaultWorkoutData.saveData()
            print("New day. Resetting workout data.")
        }
    }
}
