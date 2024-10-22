//
//  ExercisesView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/25/24.
//

import SwiftUI

// Page for recommended exercises
struct ExerciseView: View {
    @State private var showButtons = true
    @State private var muscleTarget = "abdominals"
    @State private var dataFetched = false
    @State private var exerciseData: ExerciseData?
    
    var body: some View {
        VStack {
            // Check if exercises are fetched
            if let exerciseData = exerciseData {
                ExerciseListView(muscleTarget: $muscleTarget, exerciseData: exerciseData,
                        onExerciseDataFetched: { fetchedData in
                        self.exerciseData = fetchedData
                    }
                )
            } else {
                ProgressView()
            }
        }
        .onAppear {
            // Fetch exercises on view appear
            ExerciseManager.fetchExercises(muscleType: "abdominals") { result in
                switch result {
                case .success(let fetchedExerciseData):
                    exerciseData = fetchedExerciseData
                    dataFetched = true
                case .failure(let error):
                    print("Error fetching exercises: \(error)")
                }
            }
        }
    }
}
