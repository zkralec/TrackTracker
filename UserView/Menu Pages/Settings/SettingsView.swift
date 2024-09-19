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
    
    init() {
        loadEvents()
        loadPR()
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
        print("Loaded PRs: \(prs)") // Log the loaded PRs to ensure they are correct
    }
    
    // Load the user's selected events
    private func loadEvents() {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            events = savedEvents.compactMap { EventData(rawValue: $0) }
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
                        Section {
                            VStack {
                                if viewModel.events.isEmpty {
                                    HStack {
                                        Spacer()
                                        
                                        Text("No selected events")
                                            .foregroundStyle(.secondary)
                                            .padding()
                                        
                                        Spacer()
                                    }
                                } else {
                                    Text("Event PRs")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .padding()
                                    ForEach(viewModel.events, id: \.self) { event in
                                        HStack {
                                            Text(event.rawValue)
                                                .padding(5)
                                                .roundedBackground()
                                            
                                            Spacer()
                                            
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
                        
                        Section {
                            Toggle("Dark Mode", isOn: $viewModel.isDarkMode)
                                .onChange(of: viewModel.isDarkMode){
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                        windowScene.windows.first?.overrideUserInterfaceStyle = viewModel.isDarkMode ? .dark : .light
                                    }
                                }
                        }
                        .listSectionSpacing(15)
                        
                        Section {
                            // Future toggle for notifications
                        }
                        .listSectionSpacing(15)
                        
                        // Allows user to navigate to EventView to change their selected events
                        Section {
                            VStack {
                                Button(action: {
                                    withAnimation {
                                        viewModel.currPage = 5
                                    }
                                }) {
                                    HStack {
                                        Text("Modify Selected Events")
                                            .padding(.vertical)
                                            .foregroundStyle(.blue)
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.blue)
                                            .frame(width: 70)
                                        
                                        Spacer()
                                    }
                                    .fontWeight(.medium)
                                    .font(.system(size: 20))
                                }
                                .buttonStyle(ButtonPress())
                            }
                        }
                        .listSectionSpacing(15)
                        
                        // Allows user to navigate to MeetView to change their meet days
                        Section {
                            VStack {
                                Button(action: {
                                    withAnimation {
                                        viewModel.currPage = 6
                                    }
                                }) {
                                    HStack {
                                        Text("Modify Meet Days")
                                            .padding(.vertical)
                                            .foregroundStyle(.blue)
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.blue)
                                            .frame(width: 70)
                                        
                                        Spacer()
                                    }
                                    .fontWeight(.medium)
                                    .font(.system(size: 20))
                                }
                                .buttonStyle(ButtonPress())
                            }
                        }
                        .listSectionSpacing(15)
                        
                        // Allows user to navigate to UserInputView to change their information
                        Section {
                            VStack {
                                Button(action: {
                                    withAnimation {
                                        GlobalVariables.userInput = false
                                        viewModel.currPage = -1
                                    }
                                }) {
                                    HStack {
                                        Text("Modify User Info")
                                            .padding(.vertical)
                                            .foregroundStyle(.blue)
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.blue)
                                            .frame(width: 70)
                                        
                                        Spacer()
                                    }
                                    .fontWeight(.medium)
                                    .font(.system(size: 20))
                                }
                                .buttonStyle(ButtonPress())
                            }
                        }
                        .listSectionSpacing(15)
                    }
                    .modifier(ToolbarModifier(isFocused: $viewModel.isFocused))
                    .background(Color.gray.opacity(0.05))
                    .onAppear {
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
