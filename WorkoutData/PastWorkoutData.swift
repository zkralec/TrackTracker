//
//  PastWorkoutData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 5/2/24.
//

import Foundation

// Keeps track of all the past workout data
struct PastWorkoutData: Codable {
    var pastWorkouts: [WorkoutData]
    
    // Initialize with an empty array of past workouts
    init() {
        self.pastWorkouts = []
    }
    
    // Load past workout data from UserDefaults
    static func loadPast() -> PastWorkoutData {
        if let data = UserDefaults.standard.data(forKey: "pastWorkoutData") {
            do {
                let decodedData = try JSONDecoder().decode(PastWorkoutData.self, from: data)
                return decodedData
            } catch {
                print("Error decoding past workout data: \(error)")
            }
        }
        return PastWorkoutData()
    }
    
    // Save past workout data to UserDefaults
    func savePast() {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: "pastWorkoutData")
            print("Saved past workout data!")
        } catch {
            print("Error encoding past workout data: \(error.localizedDescription)")
        }
    }
    
    // Update past workout data with a new workout
    mutating func update(with workout: WorkoutData) {
        // Add the new workout to the list of past workouts
        pastWorkouts.append(workout)
        
        // Keep only the last 10 workouts
        if pastWorkouts.count > 10 {
            pastWorkouts.removeFirst(pastWorkouts.count - 10)
        }
    }
    
    // Remove workout data from a specific date
    mutating func removeWorkout(from date: Date) {
        pastWorkouts.removeAll { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}
