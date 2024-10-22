//
//  NavigationBar.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/8/24.
//

import SwiftUI

// This is the bar at the bottom of almost every page for navigation
struct NavigationBar: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                    .padding(.top, -8)
                // Navigation buttons
                HStack {
                    VStack {
                        // Exercise button
                        NavigationStack {
                            NavigationLink {
                                ExerciseView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                Image(systemName: "dumbbell.fill")
                                    .foregroundStyle(.blue)
                                    .frame(width: 30, height: 30)
                            }
                            .frame(width: 70, height: 30)
                            .buttonStyle(ButtonPress())
                            
                            Text("Exercises")
                                .font(.caption)
                                .foregroundStyle(.blue)
                                .padding(4)
                        }
                    }
                    
                    VStack {
                        // Workout button
                        NavigationLink {
                            WorkoutView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image(systemName: "figure.run")
                                .foregroundStyle(.blue)
                                .frame(width: 30, height: 30)
                        }
                        .frame(width: 70, height: 30)
                        .buttonStyle(ButtonPress())
                        
                        Text("Workouts")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                    
                    VStack {
                        // Home button
                        NavigationLink {
                            HomeView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image(systemName: "house.fill")
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(CustomCircleButtonStyle())
                        .frame(width: 70, height: 30)
                    }
                    
                    VStack {
                        // Meals button
                        NavigationLink {
                            MealsView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image(systemName: "fork.knife")
                                .foregroundStyle(.blue)
                                .frame(width: 30, height: 30)
                        }
                        .frame(width: 70, height: 30)
                        .buttonStyle(ButtonPress())
                        
                        Text("Meals")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                    
                    VStack {
                        // Settings button
                        NavigationLink {
                            ProfileView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.blue)
                                .frame(width: 30, height: 30)
                        }
                        .frame(width: 70, height: 30)
                        .buttonStyle(ButtonPress())
                        
                        Text("Profile")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                }
                .padding(.bottom,-10)
                .padding(.top,8)
            }
        }
    }
}
