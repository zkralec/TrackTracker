//
//  StreakData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import Foundation

struct StreakData {
    static func updateStreakIfNeeded(fieldModified: Bool) {
        // Get the current date
        let today = Calendar.current.startOfDay(for: Date())
        let userDefaults = UserDefaults.standard
        
        // Check if theres a last streak update
        if let lastStreakUpdateDate = userDefaults.object(forKey: "lastStreakUpdateDate") as? Date {
            // Get the last update
            let lastUpdateDay = Calendar.current.startOfDay(for: lastStreakUpdateDate)
            
            // Calculate days betwen last streak update
            let dayDifference = Calendar.current.dateComponents([.day], from: lastUpdateDay, to: today).day ?? 0
            
            // More than 2 days reset streak
            if dayDifference >= 2 {
                print("Day difference > 2, resetting streak")
                userDefaults.set(0, forKey: "streakCount")
            } else if today != lastUpdateDay && fieldModified {
                // Modified today and no update increase streak
                print("Fields are modified, increasing streak")
                var streakCount = userDefaults.integer(forKey: "streakCount")
                streakCount += 1
                userDefaults.set(streakCount, forKey: "streakCount")
            } else {
                // No streak modification
                print("No streak increase or reset needed")
            }
        } else {
            // Set initial streak count
            print("Setting initial value of streak")
            userDefaults.set(0, forKey: "streakCount")
        }
        
        // Update the last streak update today
        userDefaults.set(today, forKey: "lastStreakUpdateDate")
        
        // Sync
        userDefaults.synchronize()
    }
    
    static func streakCount() -> Int {
        return UserDefaults.standard.integer(forKey: "streakCount")
    }
}
