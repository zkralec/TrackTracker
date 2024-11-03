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
                    
                    List {
                        // Add weights info here:
                        // Exercise
                        Section("Exercise") {
                            TextField("Exercise Name", text: $exercise,
                                      onEditingChanged: { changed in
                                
                            })
                            .padding(10)
                            .roundedBackground()
                        }
                        
                        // Weight
                        Section("Weight") {
                            Text("Placeholder")
                        }
                        
                        // Reps
                        Section("Reps") {
                            Text("Placeholder")
                        }
                        
                        // Sets
                        Section("Sets") {
                            Text("Placeholder")
                        }
                    }
                    .listSectionSpacing(15)
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
