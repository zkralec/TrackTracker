//
//  HomeView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import SwiftUI

// Main page for the user, shows a variety of info
struct HomeView: View {
    @State private var isSideMenuOpen = false
    @State private var prs = [EventData: String]()
    @State private var meetLog: [MeetData] = []
    @State private var meets: [Date] = []
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        ZStack {
                            // Display title
                            TitleBackground(title: "Home")
                            
                            HStack {
                                // Menu bar icon
                                MenuButton(isSideMenuOpen: $isSideMenuOpen)
                                Spacer()
                            }
                        }
                        Divider()
                    }
                    .padding(.bottom, -8)
                    
                    List {
                        // Current streak of tracking workouts
                        Section("Streak") {
                            HStack {
                                Spacer()
                                
                                VStack {
                                    Text("Workout Input Streak")
                                    Text("\(StreakData.streakCount())")
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundStyle(.primary)
                                }
                                .padding()
                                
                                Spacer()
                            }
                        }
                        
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
                            .padding()
                        }
                        
                        // Display meet dates
                        Section("Meet Days") {
                            HStack {
                                Spacer()
                                
                                VStack {
                                    if meetLog.isEmpty {
                                        Text("No meet days selected")
                                            .foregroundStyle(.secondary)
                                    } else {
                                        ForEach(meetLog.indices, id: \.self) { index in
                                            let meet = meetLog[index]
                                            Text("\(meet.meetDate.formatted()) | \(meet.meetLocation)")
                                                .font(.footnote)
                                                .padding(5)
                                                .roundedBackground()
                                        }
                                    }
                                }
                                .onAppear {
                                    loadPR()
                                    loadMeets()
                                    
                                    for index in stride(from: meetLog.count - 1, through: 0, by: -1) {
                                        let meet = meetLog[index]
                                        if meet.meetDate < Date() {
                                            deleteMeet(at: index)
                                        }
                                    }
                                }
                                .padding()
                                
                                Spacer()
                            }
                        }
                    }
                    .listSectionSpacing(15)
                    
                    // Navigation bar buttons
                    NavigationBar()
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
    
    // Load in the current meets
    func loadMeets() {
        if let data = UserDefaults.standard.data(forKey: "meetLog"),
           let decoded = try? JSONDecoder().decode([MeetData].self, from: data) {
            meetLog = decoded
        }
    }
    
    // Remove past meet dates
    private func deleteMeet(at index: Int) {
        meetLog.remove(at: index)
        saveMeetLog()
    }
    
    // Save the meet log to UserDefaults
    private func saveMeetLog() {
        if let encoded = try? JSONEncoder().encode(meetLog) {
            UserDefaults.standard.set(encoded, forKey: "meetLog")
        }
    }
    
    // Load the user's event PRs
    func loadPR() {
        for event in events {
            if let prValue = UserDefaults.standard.string(forKey: event.rawValue) {
                prs[event] = prValue
            }
        }
    }
    
    // Removes the notification generated by the meet date
    func removeNotification(for date: Date) {
        let identifier = date.formatted()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
