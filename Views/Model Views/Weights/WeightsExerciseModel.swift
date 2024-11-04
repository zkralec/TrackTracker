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
    @State var count: Int
    
    var body: some View {
        List {
            // Add weights info here:
            DisclosureGroup(discTitle) {
                ForEach(0..<count, id: \.self) { index in
                    // Exercise
                    Section("Exercise") {
                        TextField("Exercise Name", text: Binding(
                            get: { exercise },
                            set: { newValue in
                                exercise = newValue
                            }
                        ))
                        .padding(10)
                        .roundedBackground()
                    }
                    
                    // Weight
                    Section("Weight") {
                        TextField("Weight (lbs)", text: Binding(
                            // Want to format as:
                            // HStack {
                            //      TextField(Weight 1)
                            //      TextField(Weight 2)
                            //      TextField(Weight 3)
                            //      ...
                            // }
                            get: { weight[index] },
                            set: { newValue in
                                weight[index] = newValue
                            }
                        ))
                        .padding(10)
                        .roundedBackground()
                    }
                    
                    // Reps
                    Section("Reps") {
                        TextField("Reps", text: Binding(
                            get: { reps[index] },
                            set: { newValue in
                                reps[index] = newValue
                            }
                        ))
                        .padding(10)
                        .roundedBackground()
                    }
                    
                    // Sets
                    Section("Sets") {
                        TextField("Sets", text: Binding(
                            get: { sets },
                            set: { newValue in
                                sets = newValue
                            }
                        ))
                        .padding(10)
                        .roundedBackground()
                    }
                }
            }
        }
        .listSectionSpacing(15)
    }
}

#Preview {
    WeightsExerciseModel(exercise: "Bench Press", weight: ["155", "175", "195", "205", "225"], reps: ["5", "5", "5", "3", "3"], sets: "5", discTitle: "Exercise 1", count: 1)
}
