//
//  WeightsView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/1/24.
//

import SwiftUI

struct WeightsView: View {
    @State private var isSideMenuOpen = false
    @State private var fullWeights: [String] = [""]
    @State private var exercise = ""
    @State private var weight = ""
    @State private var reps = ""
    @State private var sets = ""
    @State private var suggestExercises = false
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                    // Eventually replace with user input
                    WeightsExerciseModel(exercise: "Hang Clean", weight: ["135", "145", "155"], reps: ["3", "3", "3"], sets: "3", discTitle: "Exercise 1")
                    // Want to add a + and - button to add or remove exercises
                    .sheet(isPresented: $suggestExercises) {
                        ExerciseView()
                    }
                    
                    // Navigation bar buttons
                    NavigationBar()
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
}

#Preview {
    WeightsView()
}
