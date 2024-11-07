//
//  ExerciseListView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/12/24.
//

import SwiftUI

// Formatts the fetched exercise data
struct ExerciseListView: View {
    @State private var muscleTitle = "Abdominals"
    
    @Binding var muscleTarget: String
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    var exerciseData: ExerciseData
    var onExerciseDataFetched: ((ExerciseData) -> Void)?
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        HStack {
                            // Subtitle
                            Text("Muscle Group:")
                                .font(.headline)
                                .fontWeight(.medium)
                                .padding(10)
                                .padding(.trailing,-11)
                            
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
                            .tint(.blue)
                            .padding(.leading, -10)
                            // Automatically changes and fetches exercises
                            .onChange(of: muscleTarget) {
                                withAnimation {
                                    fetchExercise(muscle: muscleTarget)
                                }
                            }
                        }
                    }
                    .padding(.top, 15)
                    .padding(.bottom, 5)
                    
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
                                        withAnimation {
                                            NavigationLink(destination: ExerciseDetailsView(muscleTarget: $muscleTarget, exercise: exercise)) {
                                                Text("View Details")
                                                    .foregroundStyle(.blue)
                                                    .font(.subheadline)
                                                    .padding(.top, 4)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                        .listSectionSpacing(15)
                    }
                    .onAppear {
                        muscleTarget = "abdominals"
                    }
                }
            }
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
    @Binding var muscleTarget: String
    
    var exercise: Exercise
    
    var body: some View {
        VStack {
            List {
                // Display full details of the exercise
                Section("Muscle Target") {
                    Text(muscleTarget.capitalized)
                        .padding(5)
                }
                
                Section("Exercise") {
                    Text("\(exercise.name)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                }
                
                Section("Equipment") {
                    Text(exercise.equipment.capitalized)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                }
                
                Section("Difficulty") {
                    Text(exercise.difficulty.capitalized)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                }
                
                Section("Instructions") {
                    Text(exercise.instructions.capitalizedSentence)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                }
            }
            .listSectionSpacing(5)
        }
    }
}

extension String {
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
}
