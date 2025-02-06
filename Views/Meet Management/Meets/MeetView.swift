//
//  MeetView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/18/24.
//

import SwiftUI

struct MeetView: View {
    @State private var isSideMenuOpen = false
    @State private var meetLog: [MeetData] = []
    @State private var selectedMeet: MeetData?
    @State private var isPresentingMeetDetail = false
    
    // Load selected events from UserDefaults
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        }
        return []
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        ZStack {
                            // Display title
                            TitleBackground(title: "Meet Days")
                            
                            HStack {
                                // Menu bar icon
                                MenuButton(isSideMenuOpen: $isSideMenuOpen)
                                Spacer()
                            }
                        }
                        Divider()
                    }
                    .padding(.bottom, -8)
                    
                    
                    // List of meets
                    List {
                        // Display message if no meets are logged
                        if meetLog.isEmpty {
                            Section {
                                HStack {
                                    Spacer()
                                    Text("No meets scheduled yet.")
                                        .foregroundStyle(.secondary)
                                        .padding()
                                    Spacer()
                                }
                            }
                        } else {
                            // Display each logged meet
                            ForEach(meetLog.indices, id: \.self) { index in
                                let meet = meetLog[index]
                                Section(meet.meetDate.formatted()) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            // Meet details
                                            VStack(alignment: .leading) {
                                                VStack(alignment: .leading){
                                                    Text("Location: \(meet.meetLocation)")
                                                    Text("Facility: \(meet.indoorOutdoor)")
                                                    Text("Events: \(meet.events)")
                                                }
                                                .font(.subheadline)
                                            }
                                            Spacer()
                                            
                                            // Delete button
                                            Button(action: {
                                                withAnimation {
                                                    deleteMeet(at: index)
                                                    removeNotification(for: meet.meetDate)
                                                }
                                            }) {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red)
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                                .listSectionSpacing(10)
                            }
                        }
                    }
                    // Sheet for editing injury details
                    .sheet(isPresented: $isPresentingMeetDetail) {
                        MeetEditView(meetLog: $meetLog, meet: selectedMeet ?? MeetData.default)
                    }
                    
                    VStack {
                        Divider()
                            .padding(.top, -8)
                        
                        // Button to add a new meet
                        Button(action: {
                            selectedMeet = nil
                            isPresentingMeetDetail = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Add New Meet")
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(10)
                    }
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
        .onAppear {
            loadMeetLog()
        }
    }
    
    // Delete an meet from the log
    private func deleteMeet(at index: Int) {
        print("Deleting Meet")
        meetLog.remove(at: index)
        saveMeetLog()
    }
    
    // Load the meet log from UserDefaults
    private func loadMeetLog() {
        if let data = UserDefaults.standard.data(forKey: "meetLog"),
           let decoded = try? JSONDecoder().decode([MeetData].self, from: data) {
            meetLog = decoded
        }
    }
    
    // Save the meet log to UserDefaults
    private func saveMeetLog() {
        if let encoded = try? JSONEncoder().encode(meetLog) {
            UserDefaults.standard.set(encoded, forKey: "meetLog")
        }
    }
    
    // Removes the notification generated by the last meet date
    func removeNotification(for date: Date) {
        let identifier = date.formatted()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
