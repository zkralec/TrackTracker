//
//  SettingsView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import SwiftUI
import Combine

// Holds all the settings the user can modify
class SettingsViewModel: ObservableObject {
    @Published var currPage: Int = 4
    @Published var prs = [EventData: String]()
    @Published var meets: [Date] = []
    @Published var isFocused = false
    @Published var isSideMenuOpen = false
    @Published var events: [EventData] = []
    @Published var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode") {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    @Published var isNotificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isNotificationsEnabled, forKey: "isNotificationsEnabled")
            updateNotificationSettings()
        }
    }
    @Published var isHapticsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isHapticsEnabled, forKey: "isHapticsEnabled")
        }
    }
    
    init() {
        self.isNotificationsEnabled = UserDefaults.standard.bool(forKey: "isNotificationsEnabled")
        self.isHapticsEnabled = UserDefaults.standard.bool(forKey: "isHapticsEnabled")
    }
    
    // Save the user's event PRs
    func savePR(for event: EventData, prValue: String) {
        print("Saving PRs")
        UserDefaults.standard.set(prValue, forKey: event.rawValue)
        prs[event] = prValue
    }
    
    // Load the user's event PRs
    func loadPR() {
        print("Loading PRs")
        for event in events {
            if let prValue = UserDefaults.standard.string(forKey: event.rawValue) {
                prs[event] = prValue
            }
        }
    }
    
    // Load the user's selected events
    func loadEvents() {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            events = savedEvents.compactMap { EventData(rawValue: $0) }
        }
    }
    
    // Update the user's selected notification settings
    func updateNotificationSettings() {
        if isNotificationsEnabled {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Notifications enabled")
                } else {
                    print("Notifications disabled")
                }
            }
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("Notifications disabled")
        }
    }
}

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        if viewModel.currPage == 4 {
            ZStack {
                VStack {
                    // Menu bar icon
                    MenuButton(isSideMenuOpen: $viewModel.isSideMenuOpen)
                    
                    // Display title
                    TitleBackground(title: "Settings")
                    
                    List {
                        // Shows users their events and allows for PR input
                        Section("Event PRs") {
                            VStack {
                                // If no events
                                if viewModel.events.isEmpty {
                                    HStack {
                                        Spacer()
                                        
                                        Text("No selected events")
                                            .foregroundStyle(.secondary)
                                            .padding()
                                        
                                        Spacer()
                                    }
                                // If there are events
                                } else {
                                    ForEach(viewModel.events, id: \.self) { event in
                                        HStack {
                                            Text(event.rawValue)
                                                .padding(5)
                                                .roundedBackground()
                                            
                                            Spacer()
                                            
                                            // User can enter pr here
                                            TextField("Enter PR", text: Binding(
                                                get: {
                                                    viewModel.prs[event] ?? ""
                                                },
                                                set: { newValue in
                                                    viewModel.savePR(for: event, prValue: newValue)
                                                }
                                            ))
                                            .onTapGesture {
                                                viewModel.isFocused = true
                                            }
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .onAppear {
                                                print("Rendering event: \(event.rawValue), PR: \(viewModel.prs[event] ?? "")")
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .listSectionSpacing(15)
                        
                        
                        Section("Toggles") {
                            // Toggle for dark mode or light mode
                            Toggle("Dark Mode", isOn: $viewModel.isDarkMode)
                                .onChange(of: viewModel.isDarkMode){
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                        windowScene.windows.first?.overrideUserInterfaceStyle = viewModel.isDarkMode ? .dark : .light
                                    }
                                }
                            
                            // Toggle for notifications
                            Toggle("Enable Notifications", isOn: $viewModel.isNotificationsEnabled)
                            
                            // Toggle haptic feedback
                            Toggle("Enable Haptics", isOn: $viewModel.isHapticsEnabled)
                        }
                        .listSectionSpacing(15)
                        
                        // Allows user to go to UserInputView to change their user info
                        Section("User Data") {
                            VStack {
                                Button(action: {
                                    withAnimation {
                                        GlobalVariables.userInput = false
                                        viewModel.currPage = -1
                                    }
                                }) {
                                    HStack {
                                        Text("Modify User Data")
                                            .fontWeight(.semibold)
                                        Image(systemName: "arrow.right")
                                    }
                                    .foregroundStyle(Color.blue)
                                    .frame(width: UIScreen.main.bounds.width - 56, height: 24)
                                }
                                .buttonStyle(ButtonPress())
                            }
                        }
                        .listSectionSpacing(15)
                        
                        // Allows user to do various things with their account
                        Section("Account") {
                            // Button to sign out
                            Button {
                                print("Sign out")
                            } label: {
                                SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                            }
                            
                            // Button to delete account
                            Button {
                                print("Delete account")
                            } label: {
                                SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                            }
                        }
                    }
                    .modifier(ToolbarModifier(isFocused: $viewModel.isFocused))
                    .background(Color.gray.opacity(0.05))
                    .onAppear {
                        viewModel.loadEvents()
                        viewModel.loadPR()
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            windowScene.windows.first?.overrideUserInterfaceStyle = viewModel.isDarkMode ? .dark : .light
                        }
                    }
                }
                // Show side menu if needed
                SideBar(currPage: $viewModel.currPage, isSideMenuOpen: $viewModel.isSideMenuOpen)
            }
        } else if viewModel.currPage == -1 {
            UserInputView()
        } else if viewModel.currPage == 0 {
            WorkoutView()
        } else if viewModel.currPage == 1 {
            ExerciseView()
        } else if viewModel.currPage == 2 {
            MealsView()
        } else if viewModel.currPage == 3 {
            HomeView()
        } else if viewModel.currPage == 5 {
            EventView(events: $viewModel.events)
        } else if viewModel.currPage == 6 {
            MeetView()
        } else if viewModel.currPage == 7 {
            ProfileView()
        } else if viewModel.currPage == 8 {
            TrainingLogView()
        } else if viewModel.currPage == 9 {
            InjuryView()
        }
    }
}
