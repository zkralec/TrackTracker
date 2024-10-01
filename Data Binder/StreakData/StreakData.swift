//
//  StreakData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import Foundation

struct StreakData {
    
    static func updateStreakIfNeeded(fieldModified: Bool) {
        let userDefaults = UserDefaults.standard
        let today = Date.now
        
        // Retrieve last streak update date from UserDefaults
        if let lastStreakUpdateDate = userDefaults.object(forKey: "lastStreakUpdateDate") as? Date {
            let dayDifference = Calendar.current.dateComponents([.day], from: lastStreakUpdateDate, to: today).day ?? 0
            
            if dayDifference >= 2 {
                // Reset the streak if more than 1 day has passed
                print("Day difference > 1, resetting streak")
                userDefaults.set(0, forKey: "streakCount")
            } else if dayDifference == 1 && fieldModified {
                // Increment the streak only if it's the next day and the field was modified
                print("Fields are modified, increasing streak")
                let currentStreak = userDefaults.integer(forKey: "streakCount") + 1
                userDefaults.set(currentStreak, forKey: "streakCount")
            } else {
                // No action if it's the same day or if the field wasn't modified
                print("Streak increase not needed")
            }
        } else {
            // First-time setup of streak data
            print("Setting initial streak value")
            userDefaults.set(0, forKey: "streakCount")
        }
        
        // Update last streak update date
        userDefaults.set(today, forKey: "lastStreakUpdateDate")
    }
    
    static func streakCount() -> Int {
        return UserDefaults.standard.integer(forKey: "streakCount")
    }
}
