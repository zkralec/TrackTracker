//
//  EventSelectionView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/22/24.
//

import SwiftUI

// Allows user to choose the events they do
struct EventView: View {
    @State private var currentPage: Int = 5
    @Binding var selectedEvents: [EventData]

    var body: some View {
        if currentPage == 5 {
            VStack {
                TitleBackground(title: "Select Your Events")
                
                // List of events with navigation links
                List {
                    ForEach(EventData.allCases, id: \.self) { event in
                        Button(action: {
                            self.toggleSelection(for: event)
                        }) {
                            HStack {
                                Text(event.rawValue)
                                Spacer()
                                if self.selectedEvents.contains(event) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.gray.opacity(0.05))
                .padding()
                
                // Saves the events and returns to SettingsView
                Button("Save") {
                    UserDefaults.standard.set(selectedEvents.map { $0.rawValue }, forKey: "selectedEvents")
                    currentPage = 4
                }
                .buttonStyle(CustomButtonStyle())
                .frame(width: 120, height: 40)
                .padding(.bottom)
            }
        } else if currentPage == 4 {
            SettingsView()
        }
    }

    // ALlows the user to toggle selection
    private func toggleSelection(for event: EventData) {
        if let index = selectedEvents.firstIndex(of: event) {
            selectedEvents.remove(at: index)
        } else {
            selectedEvents.append(event)
        }
    }
}
