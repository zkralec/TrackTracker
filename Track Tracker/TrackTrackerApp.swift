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
                //.preferredColorScheme(.light) // Keeping this for now since dark mode compatibality would cause many UI errors
        }
    }
}
