//
//  Track_TrackerApp.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/14/24.
//

import SwiftUI

@main
struct TrackTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
