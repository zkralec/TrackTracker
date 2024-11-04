//
//  WeightsExerciseModel.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/4/24.
//

import SwiftUI

struct WeightsExerciseModel: View {
    @State var exercise: String
    @State var weight: [String]
    @State var reps: [String]
    @State var sets: String
    @State var discTitle: String
    
    var body: some View {
        List {
            // Add weights info here:
            DisclosureGroup(discTitle) {
                // Exercise
                Section("Exercise") {
                    TextField("Exercise Name", text: $exercise,
                              onEditingChanged: { changed in
                        
                    })
                    .padding(10)
                    .roundedBackground()
                }
                
                // Weight
                Section("Weight") {
                    Text("Placeholder")
                }
                
                // Reps
                Section("Reps") {
                    Text("Placeholder")
                }
                
                // Sets
                Section("Sets") {
                    Text("Placeholder")
                }
            }
        }
        .listSectionSpacing(15)
    }
}

#Preview {
    WeightsExerciseModel(exercise: "Bench Press", weight: ["155", "175", "195", "205", "225"], reps: ["5", "5", "5", "3", "3"], sets: "5", discTitle: "Exercise 1")
}
