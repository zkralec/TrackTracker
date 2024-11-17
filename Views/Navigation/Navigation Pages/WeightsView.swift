//
//  WeightsView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/1/24.
//

import SwiftUI

struct WeightsView: View {
    @State private var isSideMenuOpen = false
    @State private var suggestExercises = false
    @State private var isFocused = false
    @State private var exercises: [WeightExercise] = []
    @State var count: Int = 1

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        ZStack {
                            // Display title
                            TitleBackground(title: "Weights")
                            
                            HStack {
                                // Menu bar icon
                                MenuButton(isSideMenuOpen: $isSideMenuOpen)
                                
                                Spacer()
                                
                                Button {
                                    suggestExercises = true
                                } label: {
                                    Image(systemName: "info.circle")
                                        .frame(width: 70, height: 30)
                                }
                            }
                        }
                        Divider()
                    }
                    .padding(.bottom, -8)
                    
                    // Exercise Models
                    List {
                        ForEach($exercises) { $exercise in
                            Section {
                                WeightsExerciseModel(
                                    exercise: $exercise.exercise,
                                    weight: $exercise.weight,
                                    reps: $exercise.reps,
                                    discTitle: $exercise.discTitle,
                                    sets: $exercise.sets,
                                    isFocused: $isFocused
                                )
                            }
                        }
                    }
                    .listSectionSpacing(10)
                    // Presents suggested exercises for muscle group
                    .sheet(isPresented: $suggestExercises) {
                        ExerciseView()
                    }
                    
                    if !isFocused {
                        VStack {
                            Divider()
                                .padding(.top, -8)
                            // Change button style to bottom left of the list (looks like stepper?)
                            HStack {
                                Button {
                                    if count > 1 {
                                        // Remove the last exercise
                                        exercises.removeLast()
                                        count -= 1
                                    }
                                } label: {
                                    Image(systemName: "minus.circle")
                                        .foregroundStyle(.blue)
                                        .frame(width: 30, height: 30)
                                }
                                .padding(.trailing)
                                .buttonStyle(BorderlessButtonStyle())
                                
                                Button {
                                    if count < 10 {
                                        // Add a new exercise
                                        let newExercise = WeightExercise(exercise: "", weight: [""], reps: [""], discTitle: "Exercise \(exercises.count + 1)", sets: 1)
                                        exercises.append(newExercise)
                                        count += 1
                                    }
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .foregroundStyle(.blue)
                                        .frame(width: 30, height: 30)
                                }
                                .padding(.leading)
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .roundedBackground()
                            .padding(.bottom, 16)
                        }
                        
                        // Navigation bar buttons
                        NavigationBar()
                    }
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
        .onAppear {
            // Load weight data and check for new day
            let loadedExercises = WeightsData.loadData()
            exercises = loadedExercises.isEmpty ? [WeightExercise(exercise: "", weight: [""], reps: [""], discTitle: "Exercise 1", sets: 1)] : loadedExercises
            count = exercises.count
        }
        .onDisappear {
            // Save weight data for current day
            WeightsData.saveData(exercises)
        }
    }
}
