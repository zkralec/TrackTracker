//
//  InjuryView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 9/19/24.
//

import SwiftUI

struct InjuryView: View {
    @State private var isSideMenuOpen = false
    @State private var injuryLog: [InjuryData] = []
    @State private var selectedInjury: InjuryData?
    @State private var isPresentingInjuryDetail = false
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
            NavigationStack {
                ZStack {
                    VStack {
                        ZStack {
                            // Display title
                            TitleBackground(title: "Injury Log")
                            
                            HStack {
                                // Menu bar icon
                                MenuButton(isSideMenuOpen: $isSideMenuOpen)
                                Spacer()
                            }
                        }
                        
                        // Button to add a new injury
                        Button(action: {
                            selectedInjury = nil
                            isEditing = false
                            isPresentingInjuryDetail = true
                        }) {
                            Text("Add New Injury")
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .padding(10)
                        
                        // List of injuries
                        List {
                            // Display message if no injuries are logged
                            if injuryLog.isEmpty {
                                Section {
                                    HStack {
                                        Spacer()
                                        Text("No injuries logged yet.")
                                            .foregroundStyle(.secondary)
                                            .padding()
                                        Spacer()
                                    }
                                }
                            } else {
                                // Display each logged injury
                                ForEach(injuryLog.indices, id: \.self) { index in
                                    let injury = injuryLog[index]
                                    Section("\(injury.muscleGroup) Injury") {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                // Injury details
                                                VStack(alignment: .leading) {
                                                    Text(injury.muscleGroup)
                                                        .font(.headline)
                                                        .padding(2)
                                                    VStack(alignment: .leading){
                                                        Text("Date: \(injury.injuryDate, style: .date)")
                                                        Text("Type: \(injury.injuryType)")
                                                        Text("Location: \(injury.location)")
                                                        Text("Severity: \(injury.severity) / 5")
                                                    }
                                                    .font(.subheadline)
                                                }
                                                Spacer()
                                                
                                                // Edit button
                                                Button("Edit") {
                                                    selectedInjury = injury
                                                    isEditing = true
                                                    isPresentingInjuryDetail = true
                                                }
                                                .buttonStyle(BorderlessButtonStyle())
                                                .padding(.trailing, 10)
                                                
                                                // Delete button
                                                Button(action: {
                                                    withAnimation {
                                                        deleteInjury(at: index)
                                                    }
                                                }) {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.red)
                                                }
                                                .buttonStyle(BorderlessButtonStyle())
                                            }
                                            .padding(.vertical, 4)
                                            
                                            // Navigation to details view
                                            NavigationLink(destination: InjuryDetailsView(injury: injury, injuryLog: $injuryLog)) {
                                                Text("View Details")
                                                    .font(.subheadline)
                                                    .foregroundColor(.blue)
                                                    .padding(.top, 4)
                                            }
                                        }
                                        .padding(.bottom, 10)
                                    }
                                    .listSectionSpacing(15)
                                }
                            }
                        }
                        // Sheet for editing injury details
                        .sheet(isPresented: $isPresentingInjuryDetail) {
                            InjuryEditView(injuryLog: $injuryLog, injury: selectedInjury ?? InjuryData.default, isEditing: isEditing)
                        }
                        .onChange(of: isPresentingInjuryDetail) {
                            if selectedInjury != nil {
                                isEditing = true
                            } else {
                                isEditing = false
                            }
                        }
                    }
                    // Show side menu if needed
                    SideBar(isSideMenuOpen: $isSideMenuOpen)
                }
            }
            .onAppear {
                loadInjuryLog()
            }
        }
    }
    
    // Delete an injury from the log
    private func deleteInjury(at index: Int) {
        injuryLog.remove(at: index)
        saveInjuryLog()
    }
    
    // Load the injury log from UserDefaults
    private func loadInjuryLog() {
        if let data = UserDefaults.standard.data(forKey: "injuryLog"),
           let decoded = try? JSONDecoder().decode([InjuryData].self, from: data) {
            injuryLog = decoded
        }
    }
    
    // Save the injury log to UserDefaults
    private func saveInjuryLog() {
        if let encoded = try? JSONEncoder().encode(injuryLog) {
            UserDefaults.standard.set(encoded, forKey: "injuryLog")
        }
    }
}
