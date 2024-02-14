//
//  ExerciseListView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/12/24.
//

import SwiftUI

// Formatts the fetched exercise data
struct ExerciseListView: View {
    @State private var currentPage: Int = 1
    @Binding var muscleTarget: String
    @Binding var showButtons: Bool
    
    var exerciseData: ExerciseData
    var onExerciseDataFetched: ((ExerciseData) -> Void)?

    var body: some View {
        if currentPage == 1 {
            // Title
            TitleBackground(title: "Exercises")
            
            if showButtons {
                VStack {
                    
                    Text("Muscle Targets")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(10)
                    
                    // Different exercise muscle target buttons
                    ScrollView(.horizontal) {
                        HStack {
                            Button(action: {
                                muscleTarget = "Abdominals"
                                fetchExercise(muscle: "abdominals")
                            }) {
                                Text("Abs")
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(CustomButtonStyle())
                            .padding(.leading, 17)
                            .padding(.horizontal, 6)
                            
                            Button(action: {
                                muscleTarget = "Abductors"
                                fetchExercise(muscle: "abductors")
                            }) {
                                Text("Abds")
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(CustomButtonStyle())
                            .padding(.horizontal, 6)
                            
                            Button(action: {
                                muscleTarget = "Adductors"
                                fetchExercise(muscle: "adductors")
                            }) {
                                Text("Adds")
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(CustomButtonStyle())
                            .padding(.horizontal, 6)
                            
                            Button(action: {
                                muscleTarget = "Calves"
                                fetchExercise(muscle: "calves")
                            }) {
                                Text("Calves")
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(CustomButtonStyle())
                            .padding(.horizontal, 6)
                            
                            Button(action: {
                                muscleTarget = "Glutes"
                                fetchExercise(muscle: "glutes")
                            }) {
                                Text("Glutes")
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(CustomButtonStyle())
                            .padding(.horizontal, 6)
                            
                            Button(action: {
                                muscleTarget = "Hamstrings"
                                fetchExercise(muscle: "hamstrings")
                            }) {
                                Text("Hams")
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(CustomButtonStyle())
                            .padding(.horizontal, 6)
                            
                            Button(action: {
                                muscleTarget = "Quadriceps"
                                fetchExercise(muscle: "quadriceps")
                            }) {
                                Text("Quads")
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(CustomButtonStyle())
                            .padding(.trailing, 17)
                            .padding(.horizontal, 6)
                        }
                        .padding(.bottom)
                    }
                }
            }
            
            // Scrollable section for all fetched exercises
            NavigationStack {
                List {
                    ForEach(exerciseData.exercises, id: \.self) { exercise in
                        VStack(alignment: .leading) {
                            // Exercise name
                            Text(exercise.name)
                                .font(.headline)
                                .padding(.bottom, 4)
                            
                            // Equipment
                            Text("Equipment: \(exercise.equipment)")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            
                            // Difficulty
                            Text("Difficulty: \(exercise.difficulty)")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            
                            // Instructions
                            if exercise.instructions.count > 100 {
                                NavigationLink(destination: ExerciseDetailsView(showButtons: $showButtons, muscleTarget: $muscleTarget, exercise: exercise)) {
                                    Text("View Details")
                                        .foregroundStyle(.blue)
                                        .font(.subheadline)
                                        .padding(.top, 4)
                                }
                            } else {
                                Text("Instructions: \(exercise.instructions)")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding()
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.gray.opacity(0.05))
            }
            
            if showButtons {
                // Navigation buttons
                HStack {
                    VStack {
                        // Workout button
                        Button(action: {
                            currentPage = 0
                        }) {
                            Image(systemName: "figure.run")
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .frame(width: 120, height: 40)
                     
                        Text("Workouts")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                    
                    VStack {
                        // Home button
                        Button(action: {
                            currentPage = 3
                        }) {
                            Image(systemName: "house.fill")
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .frame(width: 120, height: 40)
                        
                        Text("Home")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                    
                    VStack {
                        // Meals button
                        Button(action: {
                            currentPage = 2
                        }) {
                            Image(systemName: "fork.knife")
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .frame(width: 120, height: 40)
                        
                        Text("Meals")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                }
                .padding()
            }
        } else if currentPage == 0 {
            WorkoutView()
        } else if currentPage == 2 {
            MealsView()
        } else if currentPage == 3 {
            HomeView()
        }
    }
    
    private func fetchExercise(muscle: String) {
        ExerciseManager.fetchExercises(muscleType: muscle) { result in
            switch result {
            case .success(let fetchedExerciseData):
                onExerciseDataFetched?(fetchedExerciseData)
            case .failure(let error):
                print("Error fetching exercises: \(error)")
            }
        }
    }
}

struct ExerciseDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showButtons: Bool
    @Binding var muscleTarget: String
    
    var exercise: Exercise
    private let buttonStyle = CustomButtonStyle()
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    showButtons = true
                }) {
                    Image(systemName: "arrowshape.backward.fill")
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 5)
                }
                .buttonStyle(buttonStyle)
                .padding(.vertical)
                .padding(.leading, 20)
                
                Spacer()
                
                Text("Muscle Target: \(muscleTarget)")
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding(.vertical, 10)
                    .padding(.leading, -70)
                
                Spacer()
            }
            
            List {
                // Display full details of the exercise
                Text("\(exercise.name)")
                    .padding()
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Equipment: \(exercise.equipment)")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Difficulty: \(exercise.difficulty)")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Instructions: \(exercise.instructions)")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onAppear {
                showButtons = false
                if muscleTarget == "" {
                    muscleTarget = "Abdominals"
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
