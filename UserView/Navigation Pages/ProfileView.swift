//
//  AccountInfoView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/25/24.
//

import SwiftUI

// Keeps track of the users personal info
struct ProfileView: View {
    @State private var currPage = 7
    @State private var isSideMenuOpen = false
    @State private var prs = [EventData: String]()
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    @StateObject var userDataManager = UserDataManager()
    @State private var userData: UserData?
    
    var body: some View {
        if currPage == 7 {
            ZStack {
                VStack {
                    // Menu bar icon
                    MenuButton(isSideMenuOpen: $isSideMenuOpen)
                    
                    //Display title
                    TitleBackground(title: "Profile")
                    
                    List {
                        // User information display section
                        Section("General") {
                            HStack {
                                Spacer()
                                
                                VStack {
                                    // Display user information
                                    if let userData = userDataManager.userData {
                                        HStack {
                                            Text("FL")
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.white)
                                            .frame(width: 72, height: 72)
                                            .background(Color(.systemGray3))
                                            .clipShape(Circle())
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                HStack {
                                                    Text("First")
                                                        .padding(5)
                                                        .padding(.trailing, -6)
                                                    Text("Last")
                                                        .padding(5)
                                                        .padding(.leading, -6)
                                                }
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                
                                                Text("name@example.com")
                                                    .font(.footnote)
                                                    .tint(.secondary)
                                                    .padding(.leading, 6)
                                            }
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .roundedBackground()
                                        .padding()
                                        
                                        HStack {
                                            VStack(alignment: .trailing, spacing: 4) {
                                                Text("Height: \(userData.heightFeet)' \(userData.heightInches)\"")
                                                    .font(.subheadline)
                                                    .padding(5)
                                                    .roundedBackground()
                                                Text("Weight: \(formatWeight(userData.weight))")
                                                    .font(.subheadline)
                                                    .padding(5)
                                                    .roundedBackground()
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Age: \(userData.age + 18)")
                                                    .font(.subheadline)
                                                    .padding(5)
                                                    .roundedBackground()
                                                Text("Gender: \(userData.gender.rawValue)")
                                                    .font(.subheadline)
                                                    .padding(5)
                                                    .roundedBackground()
                                            }
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.bottom)
                        }
                        .listSectionSpacing(15)
                        
                        // User can see main events and their PR
                        Section("Personal Records") {
                            VStack {
                                if events.isEmpty {
                                    HStack {
                                        Spacer()
                                        
                                        Text("No selected events")
                                            .foregroundStyle(.secondary)
                                            .padding()
                                        
                                        Spacer()
                                    }
                                } else {
                                    // Go and get each event and pr for that event (if any)
                                    ForEach(events, id: \.self) { event in
                                        if let record = prs[event], !record.isEmpty {
                                            HStack {
                                                Text(event.rawValue)
                                                Spacer()
                                                Text(record)
                                            }
                                            .padding(.vertical, 4)
                                        } else {
                                            HStack {
                                                Text(event.rawValue)
                                                Spacer()
                                                Text("Enter in Settings")
                                                    .foregroundStyle(.secondary)
                                            }
                                            .padding(.vertical, 4)
                                        }
                                    }
                                }
                            }
                            .onAppear {
                                loadPR()
                            }
                            .padding()
                        }
                        .listSectionSpacing(15)
                        
                        // Shows the user the longest streak they have maintained
                        Section {
                            
                        }
                        .listSectionSpacing(15)
                    }
                   
                    // Navigation bar buttons
                    VStack {
                        NavigationBar(currPage: $currPage)
                    }
                }
                // Show side menu if needed
                SideBar(currPage: $currPage, isSideMenuOpen: $isSideMenuOpen)
            }
        } else if currPage == 0 {
            WorkoutView()
        } else if currPage == 1 {
            ExerciseView()
        } else if currPage == 2 {
            MealsView()
        } else if currPage == 3 {
            HomeView()
        } else if currPage == 4 {
            SettingsView()
        } else if currPage == 5 {
            EventView(events: $events)
        } else if currPage == 6 {
            MeetView()
        } else if currPage == 8 {
            TrainingLogView()
        } else if currPage == 9 {
            InjuryView()
        }
    }
    
    // Format weight to display with correct units
    private func formatWeight(_ weight: Double) -> String {
        let weightFormatter = NumberFormatter()
        weightFormatter.maximumFractionDigits = weight.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 1
        return "\(weightFormatter.string(from: NSNumber(value: weight)) ?? "") lbs"
    }
    
    // Load the user's event PRs
    func loadPR() {
        for event in events {
            if let prValue = UserDefaults.standard.string(forKey: event.rawValue) {
                prs[event] = prValue
            }
        }
    }
}

#Preview {
    ProfileView().preferredColorScheme(.dark)
}
