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
    @State var discTitle: String
    @State var sets: Int = 1  // Make 'sets' a mutable @State variable
    
    var body: some View {
        List {
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
                        ForEach(0..<sets, id: \.self) { index in
                            TextField("Weight (lbs)", text: Binding(
                                get: { weight[index] },
                                set: { newValue in
                                    if weight.count > index {
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
                                get: { reps[index] },
                                set: { newValue in
                                    if reps.count > index {
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
                    HStack {
                        Spacer()
                        
                        Button {
                            if sets > 1 {
                                sets -= 1
                                weight.removeLast()
                                reps.removeLast()
                            }
                        } label: {
                            Image(systemName: "minus.circle")
                                .foregroundStyle(.blue)
                                .frame(width: 50, height: 30)
                        }
                        .contentShape(Rectangle())
                        
                        Text("\(sets)")
                            .multilineTextAlignment(.center)
                            .frame(width: 50)
                            .roundedBackground()
                        
                        Button {
                            if sets < 5 {
                                sets += 1
                                weight.append("")
                                reps.append("")
                            }
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundStyle(.blue)
                                .frame(width: 50, height: 30)
                        }
                        .contentShape(Rectangle())
                        
                        Spacer()
                    }
                }
            }
        }
        .listSectionSpacing(2)
    }
}

#Preview {
    WeightsExerciseModel(exercise: "Bench Press", weight: ["155", "175", "195", "205", "225"], reps: ["5", "5", "5", "3", "3"], discTitle: "Exercise 1")
}
