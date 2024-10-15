//
//  Track_TrackerApp.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/14/24.
//

import SwiftUI
import Firebase

@main
struct TrackTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(viewModel)
                .environmentObject(settingsViewModel)
                .onAppear {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        windowScene.windows.first?.overrideUserInterfaceStyle = settingsViewModel.isDarkMode ? .dark : .light
                    }
                }
        }
    }
}
