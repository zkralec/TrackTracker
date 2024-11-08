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
    @State private var sets = "1"
    @State private var discTitle = ""
    @State private var suggestExercises = false
    @State var count: Int = 1
    
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
                    
                    HStack {
                        Button {
                            if count > 1 {
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
                                count += 1
                            }
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundStyle(.blue)
                                .frame(width: 50, height: 30)
                        }
                        .padding(.leading)
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    
                    // Exercise Models
                    List {
                        ForEach(1..<count+1, id: \.self) { index in
                            Section {
                                WeightsExerciseModel(exercise: exercise, weight: [weight], reps: [reps], discTitle: "Exercise \(index)")
                            }
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
        .onAppear {
            // Load weight data if not a new day
        }
        .onDisappear {
            // Save weight data for current day
            // Possibly add to TrainingLogView
        }
    }
}

#Preview {
    WeightsView()
}
