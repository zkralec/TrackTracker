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
                    TextField("Exercise Name", text: Binding(
                        get: { exercise },
                        set: { newValue in
                            exercise = newValue
                        }
                    ))
                    .multilineTextAlignment(.center)
                    .roundedBackground()
                }
                
                // Weight
                Section("Weight") {
                    HStack {
                        ForEach(0..<weight.count, id: \.self) { index in // Future: Replace weight.count with sets
                            TextField("Weight (lbs)", text: Binding(
                                get: { weight[index] },
                                set: { newValue in
                                    weight[index] = newValue
                                }
                            ))
                            .multilineTextAlignment(.center)
                            .roundedBackground()
                        }
                    }
                }
                
                // Reps
                Section("Reps") {
                    HStack {
                        ForEach(0..<reps.count, id: \.self) { index in // Future: Replace reps.count with sets
                            TextField("Reps", text: Binding(
                                get: { reps[index] },
                                set: { newValue in
                                    reps[index] = newValue
                                }
                            ))
                            .multilineTextAlignment(.center)
                            .roundedBackground()
                        }
                    }
                }
                
                // Sets
                Section("Sets") {
                    TextField("Sets", text: Binding(
                        get: { sets },
                        set: { newValue in
                            sets = newValue
                        }
                    ))
                    .multilineTextAlignment(.center)
                    .roundedBackground()
                }
            }
        }
        .listSectionSpacing(2)
    }
}

#Preview {
    WeightsExerciseModel(exercise: "Bench Press", weight: ["155", "175", "195", "205", "225"], reps: ["5", "5", "5", "3", "3"], sets: "5", discTitle: "Exercise 1")
}
