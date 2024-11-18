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
    @State private var isEditing: Bool = false
    
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
                        // Display message if no injuries are logged
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
                            // Display each logged injury
                            ForEach(meetLog.indices, id: \.self) { index in
                                let meet = meetLog[index]
                                Section("\(meet.meetDate) Meet") {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            // Injury details
                                            VStack(alignment: .leading) {
                                                //Text(meet.meetDate[index])
                                                    //.font(.headline)
                                                    //.padding(2)
                                                VStack(alignment: .leading){
                                                    Text("Location: \(meet.meetLocation)")
                                                    Text("Facility: \(meet.indoorOutdoor)")
                                                    Text("Events: \(meet.events)")
                                                }
                                                .font(.subheadline)
                                            }
                                            Spacer()
                                            
                                            // Edit button
                                            Button("Edit") {
                                                selectedMeet = meet
                                                isEditing = true
                                                isPresentingMeetDetail = true
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                            .padding(.trailing, 10)
                                            
                                            // Delete button
                                            Button(action: {
                                                withAnimation {
                                                    deleteMeet(at: index)
                                                }
                                            }) {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red)
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                        }
                                        .padding(.vertical, 4)
                                    }
                                    .padding(.bottom, 10)
                                }
                                .listSectionSpacing(10)
                            }
                        }
                    }
                    // Sheet for editing injury details
                    .sheet(isPresented: $isPresentingMeetDetail) {
                        MeetEditView(meetLog: $meetLog, meet: selectedMeet ?? MeetData.default, isEditing: isEditing)
                    }
                    .onChange(of: isPresentingMeetDetail) {
                        if selectedMeet != nil {
                            isEditing = true
                        } else {
                            isEditing = false
                        }
                    }
                    
                    VStack {
                        Divider()
                            .padding(.top, -8)
                        
                        // Button to add a new injury
                        Button(action: {
                            selectedMeet = nil
                            isEditing = false
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
}

#Preview {
    MeetView()
}
