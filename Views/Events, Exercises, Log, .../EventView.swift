//
//  EventSelectionView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/22/24.
//

import SwiftUI

// Allows user to choose the events they do
struct EventView: View {
    @State private var isSideMenuOpen = false
    @Binding var events: [EventData]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        ZStack {
                            // Display title
                            TitleBackground(title: "Events")
                            
                            HStack {
                                // Menu bar icon
                                MenuButton(isSideMenuOpen: $isSideMenuOpen)
                                Spacer()
                            }
                        }
                        Divider()
                    }
                    .padding(.bottom, -8)
                    
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
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
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
