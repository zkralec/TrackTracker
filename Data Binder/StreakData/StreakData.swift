//
//  StreakData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import Foundation

struct StreakData {
    
    static func updateStreakIfNeeded(fieldModified: Bool) {
        let today = Calendar.current.startOfDay(for: Date())
        let userDefaults = UserDefaults.standard
        
        // Retrieve last streak update date from UserDefaults
        if let lastStreakUpdateDate = userDefaults.object(forKey: "lastStreakUpdateDate") as? Date {
            let lastUpdateDay = Calendar.current.startOfDay(for: lastStreakUpdateDate)
            let dayDifference = Calendar.current.dateComponents([.day], from: lastUpdateDay, to: today).day ?? 0
            
            if dayDifference >= 2 {
                // Reset the streak if more than 1 days have passed
                print("Day difference > 1, resetting streak")
                userDefaults.set(0, forKey: "streakCount")
            } else if today != lastUpdateDay && fieldModified {
                // Increment the streak only if it's the next day and the field was modified
                print("Fields are modified, increasing streak")
                var streakCount = userDefaults.integer(forKey: "streakCount")
                streakCount += 1
                userDefaults.set(streakCount, forKey: "streakCount")
            } else {
                // No streak modification
                print("No streak increase or reset needed")
            }
        } else {
            // Set initial streak
            print("Setting initial streak value")
            userDefaults.set(0, forKey: "streakCount")
        }
        
        // Update last streak update date
        userDefaults.set(today, forKey: "lastStreakUpdateDate")
        
        // Sync
        userDefaults.synchronize()
    }
    
    static func streakCount() -> Int {
        return UserDefaults.standard.integer(forKey: "streakCount")
    }
}
