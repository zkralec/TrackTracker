//
//  SettingsView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import SwiftUI

// Holds all the settings the user can modify
struct SettingsView: View {
    @State private var currPage: Int = 4
    @State private var prs = [EventData: String]()
    @State private var meets: [Date] = []
    @State private var isFocused = false
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    @StateObject var userDataManager = UserDataManager()
    
    var body: some View {
        if currPage == 4 {
            VStack {
                // Display title
                TitleBackground(title: "Settings")
            }
            
            List {
                // Display meet dates
                Section {
                    VStack {
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text("Meet Days")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .padding()
                                
                                if meets.isEmpty {
                                    Text("No meet days selected")
                                        .foregroundStyle(.secondary)
                                        .padding()
                                        .roundedBackground()
                                } else {
                                    ForEach(meets, id: \.self) { date in
                                        Text(date.formatted())
                                            .padding(5)
                                            .roundedBackground()
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.bottom)
                }
                .listSectionSpacing(15)
                
                // Shows users their events and allows for PR input
                Section {
                    VStack {
                        if events.isEmpty {
                            Text("No selected events")
                                .foregroundStyle(.secondary)
                                .padding()
                        } else {
                            Text("Selected Events")
                                .font(.headline)
                                .fontWeight(.medium)
                                .padding()
                            ForEach(events, id: \.self) { event in
                                HStack {
                                    Text(event.rawValue)
                                        .padding(5)
                                        .roundedBackground()
                                    
                                    Spacer()
                                    
                                    TextField("Enter PR", text: Binding(
                                        get: {
                                            prs[event] ?? ""
                                        },
                                        set: { newValue in
                                            prs[event] = newValue
                                            savePR(for: event, prValue: newValue)
                                        }
                                    ))
                                    .onTapGesture {
                                        self.isFocused = true
                                    }
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                }
                .listSectionSpacing(15)
                
                // Allows user to navigate to MeetView to change their meet days
                Section {
                    VStack {
                        Button(action: {
                            withAnimation {
                                currPage = 6
                            }
                        }) {
                            HStack {
                                Text("Modify Meet Days")
                                    .padding(.vertical)
                                Image(systemName: "chevron.right")
                                    .frame(width: 70)
                                
                                Spacer()
                            }
                            .foregroundStyle(.black)
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                        }
                    }
                }
                .listSectionSpacing(15)
                
                // Allows user to navigate to EventView to change their selected events
                Section {
                    VStack {
                        Button(action: {
                            withAnimation {
                                currPage = 5
                            }
                        }) {
                            HStack {
                                Text("Modify Selected Events")
                                    .padding(.vertical)
                                Image(systemName: "chevron.right")
                                    .frame(width: 70)
                                
                                Spacer()
                            }
                            .foregroundStyle(.black)
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                        }
                    }
                }
                .listSectionSpacing(15)
                
                // Allows user to navigate to UserInputView to change their information
                Section {
                    VStack {
                        Button(action: {
                            withAnimation {
                                GlobalVariables.userInput = false
                                currPage = -1
                            }
                        }) {
                            HStack {
                                Text("Modify User Info")
                                    .padding(.vertical)
                                Image(systemName: "chevron.right")
                                    .frame(width: 70)
                                
                                Spacer()
                            }
                            .foregroundStyle(.black)
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                        }
                    }
                }
                .listSectionSpacing(15)
            }
            .modifier(ToolbarModifier(isFocused: $isFocused))
            .background(Color.gray.opacity(0.05))
            .onAppear {
                loadPR()
                loadMeets()
            }
            
            // Navigation bar buttons
            if !isFocused {
                VStack {
                    NavigationBar(currPage: $currPage)
                }
            }
            
        } else if currPage == -1 {
            UserInputView()
        } else if currPage == 0 {
            WorkoutView()
        } else if currPage == 1 {
            ExerciseView()
        } else if currPage == 2 {
            MealsView()
        } else if currPage == 3 {
            HomeView()
        } else if currPage == 5 {
            EventView(events: $events)
        } else if currPage == 6 {
            MeetView()
        } else if currPage == 7 {
            ProfileView()
        }
    }
    
    // Load in the current meet dates
    func loadMeets() {
        print("Loading meets")
        if let data = UserDefaults.standard.data(forKey: "meetDates") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Date].self, from: data) {
                meets = decoded
            }
        }
        print("Loaded meets")
    }
    
    // Save the user's event PRs
    func savePR(for event: EventData, prValue: String) {
        print("Saving PRs")
        print("PR: \(prValue)")
        print("Event: \(event.rawValue)")
        for (event, prValue) in prs {
            UserDefaults.standard.set(prValue, forKey: event.rawValue)
        }
    }
    
    // Load the user's event PRs
    func loadPR() {
        print("Loading PRs")
        for event in events {
            if let prValue = UserDefaults.standard.string(forKey: event.rawValue) {
                prs[event] = prValue
            }
        }
        print("Loaded PRs")
    }
}

#Preview {
    SettingsView()
}
