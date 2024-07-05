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
    var sets: Int
    
    var recovery: Bool
    var off: Bool
    var meet: Bool
    var technique: Bool
    var workout: Bool
    var tempo: Bool
    
    var dayComplete: Bool
    
    var track: Bool
    var indoorTrack: Bool
    var dirt: Bool
    var grasshills: Bool
    var asphalt: Bool
    
    var rain: Bool
    var snow: Bool
    var windy: Bool
    var normal: Bool
    var hot: Bool
    var cold: Bool
    
    var blocks: Bool
    var resistanceBand: Bool
    var weights: Bool
    var sled: Bool
    var wickets: Bool
    var hurdles: Bool
    var weightedVest: Bool
    var plyoBox: Bool
    var medicineBall: Bool
    var stationaryBike: Bool
    var treadmill: Bool
    
    var injury: Bool
    var soreness: Bool
    var fatigued: Bool
    var peakForm: Bool
    
    var low: Bool
    var moderate: Bool
    var high: Bool
    var maximum: Bool
    
    var highJump: Bool
    var poleVault: Bool
    var hammerThrow: Bool
    var discus: Bool
    var shotPut: Bool
    var javelin: Bool
    var longJump: Bool
    var tripleJump: Bool
}

extension WorkoutData {
    // Function to clear all past workout data stored in UserDefaults
    static func clearAllData() {
        UserDefaults.standard.removeObject(forKey: "workoutData")
        UserDefaults.standard.removeObject(forKey: "currentDate")
        print("Cleared all past workout data.")
    }
    
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
    
    // Saves the user workout data to storage and updates past workout data
    func saveData() {
        // Check if the saved data is different from the current data or if it's a new day
        if let savedData = loadData() {
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
                                                 sets: 0,
                                                 
                                                 recovery: false,
                                                 off: false,
                                                 meet: false,
                                                 technique: false,
                                                 workout: false,
                                                 tempo: false,
                                                 
                                                 dayComplete: false,
                                                 
                                                 track: false,
                                                 indoorTrack: false,
                                                 dirt: false,
                                                 grasshills: false,
                                                 asphalt: false,
                                                 
                                                 rain: false,
                                                 snow: false,
                                                 windy: false,
                                                 normal: false,
                                                 hot: false,
                                                 cold: false,
                                                 
                                                 blocks: false,
                                                 resistanceBand: false,
                                                 weights: false,
                                                 sled: false,
                                                 wickets: false,
                                                 hurdles: false,
                                                 weightedVest: false,
                                                 plyoBox: false,
                                                 medicineBall: false,
                                                 stationaryBike: false,
                                                 treadmill: false,
                                                 
                                                 injury: false,
                                                 soreness: false,
                                                 fatigued: false,
                                                 peakForm: false,
                                                 
                                                 low: false,
                                                 moderate: false,
                                                 high: false,
                                                 maximum: false,
                                                 
                                                 highJump: false,
                                                 poleVault: false,
                                                 hammerThrow: false,
                                                 discus: false,
                                                 shotPut: false,
                                                 javelin: false,
                                                 longJump: false,
                                                 tripleJump: false)
            defaultWorkoutData.saveData()
            print("New day. Resetting workout data.")
        }
    }
}
