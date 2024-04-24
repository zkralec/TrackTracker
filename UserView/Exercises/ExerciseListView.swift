//
//  ExerciseListView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/12/24.
//

import SwiftUI

// Formatts the fetched exercise data
struct ExerciseListView: View {
    @State private var currPage: Int = 1
    @State private var muscleTitle = "Abdominals"
    @Binding var muscleTarget: String
    @Binding var showButtons: Bool
    
    var exerciseData: ExerciseData
    var onExerciseDataFetched: ((ExerciseData) -> Void)?

    var body: some View {
        if currPage == 1 {
            // Title
            TitleBackground(title: "Exercises")
            
            if showButtons {
                VStack {
                    // Subtitle
                    Text("Muscle Targets")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(10)
                    
                    HStack {
                        // Different exercise muscle target buttons
                        Picker("", selection: $muscleTarget) {
                            Text("Abdominals").tag("abdominals")
                            Text("Abductors").tag("abductors")
                            Text("Adductors").tag("adductors")
                            Text("Calves").tag("calves")
                            Text("Glutes").tag("glutes")
                            Text("Hamstrings").tag("hamstrings")
                            Text("Quadriceps").tag("quadriceps")
                        }
                        .tint(.black)
                        .roundedBackground()
                        // Automatically changes and fetches exercises
                        .onChange(of: muscleTarget) {
                            withAnimation {
                                fetchExercise(muscle: muscleTarget)
                            }
                        }
                        .padding()
                    }
                }
            }
            
            // Scrollable section for all fetched exercises
            NavigationStack {
                List {
                    ForEach(exerciseData.exercises, id: \.self) { exercise in
                        Section {
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
                                    withAnimation {
                                        NavigationLink(destination: ExerciseDetailsView(showButtons: $showButtons, muscleTarget: $muscleTarget, muscleTitle: $muscleTitle, exercise: exercise)) {
                                            Text("View Details")
                                                .foregroundStyle(.blue)
                                                .font(.subheadline)
                                                .padding(.top, 4)
                                        }
                                    }
                                } else {
                                    Text("Instructions: \(exercise.instructions)")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                }
                            }
                            .padding()
                        }
                        .listSectionSpacing(15)
                    }
                }
                .padding(.top, -15)
                .background(Color.gray.opacity(0.05))
            }
            
            if showButtons {
                // Navigation bar buttons
                VStack {
                    NavigationBar(currPage: $currPage)
                }
            }
        } else if currPage == 4 {
            SettingsView()
        } else if currPage == 0 {
            WorkoutView()
        } else if currPage == 2 {
            MealsView()
        } else if currPage == 3 {
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
    @Binding var muscleTitle : String
    
    var exercise: Exercise
    private let buttonStyle = CustomButtonStyle()
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                        showButtons = true
                    }
                }) {
                    Image(systemName: "arrowshape.backward.fill")
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 5)
                }
                .buttonStyle(buttonStyle)
                .padding(.vertical)
                .padding(.leading, 20)
                
                Spacer()
                
                Text("Muscle Target: \(muscleTitle)")
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding(.vertical, 10)
                    .padding(.leading, -70)
                
                Spacer()
            }
            
            List {
                // Display full details of the exercise
                Section {
                    Text("\(exercise.name)")
                        .padding()
                        .font(.title2)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listSectionSpacing(15)
                
                Section {
                    Text("Equipment: \(exercise.equipment)")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listSectionSpacing(15)
                
                Section {
                    Text("Difficulty: \(exercise.difficulty)")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listSectionSpacing(15)
                
                Section {
                    Text("Instructions: \(exercise.instructions)")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listSectionSpacing(15)
            }
            .onAppear {
                showButtons = false
                if muscleTarget == "" {
                    muscleTarget = "abdominals"
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
