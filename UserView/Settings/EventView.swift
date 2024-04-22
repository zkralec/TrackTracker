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
    @Binding var events: [EventData]

    var body: some View {
        if currPage == 5 {
            VStack {
                TitleBackground(title: "Select Your Events")
                
                // List of events with navigation links
                List {
                    ForEach(EventData.allCases, id: \.self) { event in
                        Section {
                            Button(action: {
                                self.toggleSelection(for: event)
                            }) {
                                HStack {
                                    Text(event.rawValue)
                                        .foregroundStyle(Color.black)
                                    
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
                
                // Saves the events and returns to SettingsView
                Button("Save") {
                    withAnimation {
                        UserDefaults.standard.set(events.map { $0.rawValue }, forKey: "selectedEvents")
                        currPage = 4
                    }
                }
                .buttonStyle(CustomButtonStyle())
                .frame(width: 120, height: 40)
                .padding()
            }
        } else if currPage == 4 {
            SettingsView()
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
