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
    @Published var isHapticsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isHapticsEnabled, forKey: "isHapticsEnabled")
        }
    }
    
    init() {
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
}

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var deleteConfirmation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack {
                        // Display title
                        TitleBackground(title: "Settings")
                        
                        HStack {
                            // Menu bar icon
                            MenuButton(isSideMenuOpen: $viewModel.isSideMenuOpen)
                            Spacer()
                        }
                    }
                    
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
                            
                            // Toggle haptic feedback
                            Toggle("Enable Haptics", isOn: $viewModel.isHapticsEnabled)
                        }
                        .listSectionSpacing(15)
                        
                        // Allows user to go to UserInputView to change their user info
                        Section("User Data") {
                            NavigationLink {
                                UserInputView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                SettingsRowView(imageName: "person.circle", title: "Modify User Data", tintColor: .blue)
                            }
                        }
                        .listSectionSpacing(15)
                        
                        // Allows user to do various things with their account
                        Section("Account") {
                            // Button to sign out
                            Button {
                                withAnimation {
                                    authViewModel.signOut()
                                }
                            } label: {
                                SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                            }
                            
                            // Button to delete account
                            Button {
                                deleteConfirmation = true
                            } label: {
                                SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                            }
                            .confirmationDialog("Are you sure you want to delete your account? This action is permanent.", isPresented: $deleteConfirmation, titleVisibility: .visible) {
                                Button("Delete Account") {
                                    Task {
                                        try await authViewModel.deleteAccount()
                                    }
                                }
                                Button("Cancel", role: .cancel) {}
                            }
                        }
                    }
                    .modifier(ToolbarModifier(isFocused: $viewModel.isFocused))
                    .onAppear {
                        viewModel.loadEvents()
                        viewModel.loadPR()
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            windowScene.windows.first?.overrideUserInterfaceStyle = viewModel.isDarkMode ? .dark : .light
                        }
                    }
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $viewModel.isSideMenuOpen)
            }
        }
    }
}
