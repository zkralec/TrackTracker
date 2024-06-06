//
//  EventSelectionView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/22/24.
//

import SwiftUI

// Allows user to choose the events they do
struct EventView: View {
    @State private var currPage: Int = 5
    @State private var isSideMenuOpen = false
    @Binding var events: [EventData]
    
    var body: some View {
        if currPage == 5 {
            ZStack {
                VStack {
                    // Menu bar icon
                    MenuButton(isSideMenuOpen: $isSideMenuOpen)
                    
                    TitleBackground(title: "Events")
                    
                    // List of events with navigation links
                    List {
                        ForEach(EventData.allCases, id: \.self) { event in
                            Section {
                                Button(action: {
                                    self.toggleSelection(for: event)
                                    // Saves the events
                                    UserDefaults.standard.set(events.map { $0.rawValue }, forKey: "selectedEvents")
                                    print("Saved Events")
                                }) {
                                    HStack {
                                        Text(event.rawValue)
                                            .foregroundStyle(Color.primary)
                                        
                                        Spacer()
                                        
                                        if self.events.contains(event) {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.blue)
                                        }
                                    }
                                }
                            }
                            .listSectionSpacing(5)
                        }
                    }
                    .background(Color.gray.opacity(0.05))
                }
                // Show side menu if needed
                SideBar(currPage: $currPage, isSideMenuOpen: $isSideMenuOpen)
            }
        } else if currPage == 3 {
            HomeView()
        } else if currPage == 4 {
            SettingsView()
        } else if currPage == 6 {
            MeetView()
        } else if currPage == 7 {
            ProfileView()
        } else if currPage == 8 {
            TrainingLogView()
        } else if currPage == 8 {
            TrainingLogView()
        }
    }
    
    // ALlows the user to toggle selection
    private func toggleSelection(for event: EventData) {
        if let index = events.firstIndex(of: event) {
            events.remove(at: index)
        } else {
            events.append(event)
        }
    }
}
