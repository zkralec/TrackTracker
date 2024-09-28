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
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(settingsViewModel)
                .onAppear {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        windowScene.windows.first?.overrideUserInterfaceStyle = settingsViewModel.isDarkMode ? .dark : .light
                    }
                    
                    // Update the streak when the app starts
                    StreakData.updateStreakIfNeeded(fieldModified: false)
                }
        }
    }
}
