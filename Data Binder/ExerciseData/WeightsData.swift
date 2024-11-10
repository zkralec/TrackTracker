//
//  WeightsData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/8/24.
//

import Foundation

class WeightsData {
    static let exercisesKey = "weightsExercises"
    static let lastSavedDateKey = "lastSavedDate"

    // Save exercises and last saved date
    static func saveData(_ exercises: [WeightExercise]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(exercises) {
            UserDefaults.standard.set(encoded, forKey: exercisesKey)
        }

        // Save current date as last saved date
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: lastSavedDateKey)
        print("Saved weight data")
    }
    
    // Load exercises and check if new day
    static func loadData() -> [WeightExercise] {
        let currentDate = Date()
        if let lastSavedDate = UserDefaults.standard.object(forKey: lastSavedDateKey) as? Date {
            // Check if the date is the same
            if isSameDay(date1: currentDate, date2: lastSavedDate) {
                // If same day, return saved exercises
                if let savedExercises = UserDefaults.standard.data(forKey: exercisesKey) {
                    let decoder = JSONDecoder()
                    if let loadedExercises = try? decoder.decode([WeightExercise].self, from: savedExercises) {
                        print("Loaded weight data")
                        return loadedExercises
                    }
                }
            } else {
                // If it's a new day, reset exercises
                print("New day, resetting weight data")
                return []
            }
        }
        print("Resetting weight data")
        return []
    }
    
    // Compares two days
    static func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}
