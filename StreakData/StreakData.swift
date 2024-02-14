//
//  StreakData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import Foundation

// Increases streak by 1 for each consecuative day logging workout, ff a day is missed streak is reest
struct StreakData {
    static func updateStreakIfNeeded(fieldModified: Bool) {
        let today = Calendar.current.startOfDay(for: Date())
        
        // Get last date the streak was updated
        if let lastStreakUpdateDate = UserDefaults.standard.object(forKey: "lastStreakUpdateDate") as? Date {
            let lastUpdateDay = Calendar.current.startOfDay(for: lastStreakUpdateDate)
            
            // Calculate the difference in days between today and the last streak update
            let dayDifference = Calendar.current.dateComponents([.day], from: lastUpdateDay, to: today).day ?? 0
            
            if dayDifference >= 2 {
                print("Day difference > 2, resetting streak")
                // If it has been at least two days since the last streak update, reset the streak count
                UserDefaults.standard.set(0, forKey: "streakCount")
            } else if today != lastUpdateDay && fieldModified {
                print("Fields are modified, increasing streak")
                // If the last streak update was not today and a field was modified, increase the streak count by 1
                var streakCount = streakCount()
                streakCount += 1
                UserDefaults.standard.set(streakCount, forKey: "streakCount")
            } else {
                print("No streak increase or reset needed")
            }
        } else {
            print("Setting initial value of streak")
            // If there's no last streak update date, set initial values
            UserDefaults.standard.set(0, forKey: "streakCount")
        }
        
        // Update the last streak update date to today
        UserDefaults.standard.set(today, forKey: "lastStreakUpdateDate")
    }

    static func streakCount() -> Int {
        return UserDefaults.standard.integer(forKey: "streakCount")
    }
}
