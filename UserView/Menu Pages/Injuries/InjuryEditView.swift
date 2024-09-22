//
//  InjuryDetailView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 9/20/24.
//

import SwiftUI

struct InjuryEditView: View {
    // State variables for injury details
    @State private var injuryDate: Date = Date()
    @State private var muscleGroup: String = "Hamstring"
    @State private var injuryType: String = "Strain"
    @State private var severity: Double = 1.0
    @State private var location: String = "Upper"
    @State private var allowedActivities: [String] = []
    @State private var restrictedActivities: [String] = []
    
    // Binding variables for injury log and selected injury
    @Binding var injuryLog: [InjuryData]
    var injury: InjuryData
    var isEditing: Bool
    
    // Defined muscle groups and associated injury types and locations
    let muscleGroups = ["Hamstring", "Quads", "Calves", "Shins", "Lower Back", "Hip Flexor", "Glutes", "Elbow"]
    
    var injuryTypesByMuscleGroup: [String: [String]] = [
        "Hamstring": ["Strain", "Tear", "Tendinitis"],
        "Quads": ["Strain", "Tear", "Tendinitis"],
        "Calves": ["Strain", "Tear", "Sprain"],
        "Shins": ["Shin Splints", "Stress Fracture"],
        "Lower Back": ["Strain", "Sprain"],
        "Hip Flexor": ["Strain", "Tendinitis"],
        "Glutes": ["Strain", "Tendinitis"],
        "Elbow": ["Tendinitis", "Strain", "Ligament Tear", "Bursitis"]
    ]
    
    var locationsByMuscleGroup: [String: [String]] = [
        "Hamstring": ["Upper", "Middle", "Lower"],
        "Quads": ["Upper", "Middle", "Lower"],
        "Calves": ["Upper", "Lower"],
        "Shins": ["Front", "Side"],
        "Lower Back": ["Left Side", "Right Side", "Middle"],
        "Hip Flexor": ["Left", "Right"],
        "Glutes": ["Left", "Right"],
        "Elbow": ["Inner", "Outer", "Posterior", "Ulnar Collateral Ligament"]
    ]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                TitleBackground(title: "Injury Editing")
                    .padding(.top, 28)
                
                List {
                    // Injury date
                    Section {
                        DatePicker("Injury Date", selection: $injuryDate, displayedComponents: [.date])
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                    }
                    .listSectionSpacing(15)
                    
                    // Muscle group
                    Section {
                        Picker("Muscle Group", selection: $muscleGroup) {
                            ForEach(muscleGroups, id: \.self) { group in
                                Text(group).tag(group)
                            }
                        }
                        .onChange(of: muscleGroup) {
                            // Update injury type and location based on muscle group
                            if let types = injuryTypesByMuscleGroup[muscleGroup], !types.contains(injuryType) {
                                injuryType = types.first ?? ""
                            }
                            location = locationsByMuscleGroup[muscleGroup]?.first ?? ""
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .listSectionSpacing(15)
                    
                    // Injury type
                    Section {
                        Picker("Injury Type", selection: $injuryType) {
                            if let types = injuryTypesByMuscleGroup[muscleGroup] {
                                ForEach(types, id: \.self) { type in
                                    Text(type).tag(type)
                                }
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .listSectionSpacing(15)
                    
                    // Injury location
                    Section {
                        Picker("Location", selection: $location) {
                            if let locations = locationsByMuscleGroup[muscleGroup] {
                                ForEach(locations, id: \.self) { loc in
                                    Text(loc).tag(loc)
                                }
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .listSectionSpacing(15)
                    
                    // Severity slider
                    Section {
                        VStack(alignment: .leading) {
                            Text("Severity: \(Int(severity))")
                            Slider(value: $severity, in: 1...5, step: 1)
                                .accentColor(.blue)
                        }
                        .padding()
                    }
                    .listSectionSpacing(15)
                    
                    // Confirm button
                    Section {
                        Button(action: {
                            addInjury()
                            saveInjuryLog()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Confirm")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .listSectionSpacing(15)
                }
                .background(Color(.systemGray6).opacity(0.05))
            }
        }
        .onAppear {
            // Load edited injury data
            if isEditing {
                injuryDate = injury.injuryDate
                muscleGroup = injury.muscleGroup
                injuryType = injury.injuryType
                severity = Double(injury.severity)
                location = injury.location
                allowedActivities = injury.allowedActivities
                restrictedActivities = injury.restrictedActivities
                print("Injury loaded: \(injury)")
            }
        }
    }
    
    // Reset to default values
    private func resetFields() {
        injuryDate = Date()
        muscleGroup = "Hamstring"
        injuryType = "Strain"
        severity = 1.0
        location = "Upper"
        allowedActivities = []
        restrictedActivities = []
    }
    
    // Add or update in injury log
    private func addInjury() {
        let newInjury = InjuryData(
            injuryDate: injuryDate,
            muscleGroup: muscleGroup,
            injuryType: injuryType,
            severity: Int(severity),
            location: location,
            allowedActivities: allowedActivities,
            restrictedActivities: restrictedActivities
        )
        
        if isEditing, let index = injuryLog.firstIndex(where: { $0.id == injury.id }) {
            injuryLog[index] = newInjury
        } else {
            injuryLog.append(newInjury)
        }
    }
    
    // Save the injury
    private func saveInjuryLog() {
        if let encoded = try? JSONEncoder().encode(injuryLog) {
            UserDefaults.standard.set(encoded, forKey: "injuryLog")
        }
    }
}
