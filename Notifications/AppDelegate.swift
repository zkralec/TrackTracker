//
//  AppDelegate.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/25/24.
//

import UIKit
import UserNotifications

// Used to request permission from user for notifications
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notifications permission granted")
            } else {
                print("Notifications permission denied")
            }
        }
        
        return true
    }
}
