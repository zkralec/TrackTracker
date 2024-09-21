//
//  InjuryDetailView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 9/20/24.
//

import SwiftUI

struct InjuryEditView: View {
    // States for capturing injury details
    @State private var injuryDate: Date = Date()
    @State private var muscleGroup: String = "Hamstring"
    @State private var injuryType: String = "Strain"
    @State private var severity: Double = 1.0
    @State private var location: String = "Upper"
    @State private var allowedActivities: [String] = []
    @State private var restrictedActivities: [String] = []
    
    // Shared injuryLog data
    @Binding var injuryLog: [InjuryData]
    var injury: InjuryData
    var isEditing: Bool
    
    // Muscle groups and dependent options
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
                    // Injury Date
                    Section {
                        VStack {
                            Text("Injury Date")
                                .font(.title3)
                                .fontWeight(.medium)
                                .padding()
                            
                            DatePicker("Select Date", selection: $injuryDate, displayedComponents: [.date])
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                    }
                    .listSectionSpacing(15)
                    
                    // Muscle Group
                    Section {
                        Picker("Muscle Group", selection: $muscleGroup) {
                            ForEach(muscleGroups, id: \.self) { group in
                                Text(group).tag(group)
                            }
                        }
                        .onChange(of: muscleGroup) {
                            // Update default injury type based on the muscle group
                            if let types = injuryTypesByMuscleGroup[muscleGroup], !types.contains(injuryType) {
                                injuryType = types.first ?? ""
                            }
                            // Reset location to default for the selected muscle group
                            location = locationsByMuscleGroup[muscleGroup]?.first ?? ""
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .listSectionSpacing(15)
                    
                    // Injury Type (dependent on muscle group)
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
                    
                    // Injury Location (dropdown based on muscle group and injury type)
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
                    
                    // Severity Level (Slider out of 5)
                    Section {
                        VStack(alignment: .leading) {
                            Text("Severity: \(Int(severity))")
                            Slider(value: $severity, in: 1...5, step: 1)
                                .accentColor(.blue)
                        }
                        .padding()
                    }
                    .listSectionSpacing(15)
                    
                    // Confirm Button
                    Section {
                        Button(action: {
                            // Update the injuryLog with the new or edited injury
                            if let index = injuryLog.firstIndex(where: { $0.id == injury.id }) {
                                injuryLog[index] = injury
                            } else {
                                injuryLog.append(injury)
                            }
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
    }
    
    private func saveInjuryLog() {
        if let encoded = try? JSONEncoder().encode(injuryLog) {
            UserDefaults.standard.set(encoded, forKey: "injuryLog")
        }
    }
    
}
