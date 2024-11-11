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
                        exercise = newValue
                        if formValid {
                            discTitle = exercise
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
                                if weight.indices.contains(index) {
                                    weight[index] = newValue
                                } else {
                                    weight.append(newValue)
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
                                if reps.indices.contains(index) {
                                    reps[index] = newValue
                                } else {
                                    reps.append(newValue)
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
    }
}

// Remember to add form validation for each item: Exercise (character limit), Weight (character limit), Reps (character limit)

