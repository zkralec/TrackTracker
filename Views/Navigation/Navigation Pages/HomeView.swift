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
                    ZStack {
                        // Display title
                        TitleBackground(title: "Home")
                        
                        HStack {
                            // Menu bar icon
                            MenuButton(isSideMenuOpen: $isSideMenuOpen)
                            Spacer()
                        }
                    }
                    
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
                        .listSectionSpacing(15)
                        
                        // Display meet dates
                        Section("Meet Days") {
                            HStack {
                                Spacer()
                                
                                VStack {
                                    if meets.isEmpty {
                                        Text("No meet days selected")
                                            .foregroundStyle(.secondary)
                                    } else {
                                        ForEach(meets, id: \.self) { date in
                                            Text(date.formatted())
                                                .padding(5)
                                                .roundedBackground()
                                        }
                                    }
                                }
                                .onAppear {
                                    loadPR()
                                    loadMeets()
                                }
                                .padding()
                                
                                Spacer()
                            }
                        }
                        .listSectionSpacing(15)
                    }
                    .background(Color(.systemGray6).opacity(0.05))
                    
                    // Navigation bar buttons
                    NavigationBar()
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
    
    // Load in the current meet dates
    func loadMeets() {
        if let data = UserDefaults.standard.data(forKey: "meetDates") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Date].self, from: data) {
                meets = decoded
            }
        }
        removePastMeets()
    }
    
    // Remove past meet dates
    func removePastMeets() {
        let today = Calendar.current.startOfDay(for: Date())
        meets.removeAll { meet in
            Calendar.current.startOfDay(for: meet) < today
        }
        saveMeets()
    }
    
    // Save the current meet dates
    func saveMeets() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(meets) {
            UserDefaults.standard.set(encoded, forKey: "meetDates")
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
