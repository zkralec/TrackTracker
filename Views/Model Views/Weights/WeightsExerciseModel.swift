//
//  WeightsExerciseModel.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/4/24.
//

import SwiftUI

import SwiftUI

struct WeightsExerciseModel: View {
    @Binding var exercise: String
    @Binding var weight: [String]
    @Binding var reps: [String]
    @Binding var discTitle: String
    @Binding var sets: Int
    
    var body: some View {
        DisclosureGroup(discTitle.capitalized) {
            // Exercise
            Section("Exercise") {
                TextField("Weight (lbs)", text: Binding(
                    get: { exercise },
                    set: { newValue in
                        if validateExerciseInput(newValue) {
                            exercise = newValue
                            if formValid {
                                discTitle = exercise
                            }
                        }
                    }
                ))
                .multilineTextAlignment(.center)
                .roundedBackground()
            }
            
            // Weight
            Section("Weight") {
                HStack {
                    ForEach(0..<sets, id: \.self) { index in
                        TextField("Weight (lbs)", text: Binding(
                            get: { weight.indices.contains(index) ? weight[index] : "" },
                            set: { newValue in
                                if validateWeightInput(newValue) {
                                    if weight.indices.contains(index) {
                                        weight[index] = newValue
                                    } else {
                                        weight.append(newValue)
                                    }
                                }
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
                    ForEach(0..<sets, id: \.self) { index in
                        TextField("Reps", text: Binding(
                            get: { reps.indices.contains(index) ? reps[index] : "" },
                            set: { newValue in
                                if validateRepsInput(newValue) {
                                    if reps.indices.contains(index) {
                                        reps[index] = newValue
                                    } else {
                                        reps.append(newValue)
                                    }
                                }
                            }
                        ))
                        .multilineTextAlignment(.center)
                        .roundedBackground()
                    }
                }
            }
            
            // Sets
            Section("Sets") {
                Stepper("Sets: \(sets)", value: $sets, in: 1...5)
            }
        }
    }
}

extension WeightsExerciseModel: AuthenticationFormProtocol {
    var formValid: Bool {
        return !exercise.isEmpty
        && !(exercise == " ")
        // Check if all whitespaces
    }
}

// Function to validate the input for exercise
func validateExerciseInput(_ input: String) -> Bool {
    return (input.isEmpty || input != " ") && input.count <= 30
}

// Function to validate the input for weight
func validateWeightInput(_ input: String) -> Bool {
    return (input.isEmpty || Int(input) != nil) && input.count <= 4
}

// Function to validate the input for the number of reps
func validateRepsInput(_ input: String) -> Bool {
    return (input.isEmpty || Int(input) != nil) && input.count <= 2
}
