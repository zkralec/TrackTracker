//
//  NavigationBar.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/8/24.
//

import SwiftUI

struct NavigationBar: View {
    @Binding var currPage: Int
    
    var body: some View {
        VStack {
            Divider()
                .padding(.top,-8)
            // Navigation buttons
            HStack {
                VStack {
                    // Exercise button
                    Button(action: {
                        withAnimation {
                            currPage = 1
                        }
                    }) {
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
                
                VStack {
                    // Workout button
                    Button(action: {
                        withAnimation {
                            currPage = 0
                        }
                    }) {
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
                    Button(action: {
                        withAnimation {
                            currPage = 3
                        }
                    }) {
                        Image(systemName: "house.fill")
                            .foregroundStyle(.white)
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(CustomCircleButtonStyle())
                    .frame(width: 70, height: 30)
                }
                
                VStack {
                    // Meals button
                    Button(action: {
                        withAnimation {
                            currPage = 2
                        }
                    }) {
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
                    Button(action: {
                        withAnimation {
                            currPage = 4
                        }
                    }) {
                        Image(systemName: "gear")
                            .foregroundStyle(.blue)
                            .frame(width: 30, height: 30)
                    }
                    .frame(width: 70, height: 30)
                    .buttonStyle(ButtonPress())
                    
                    Text("Settings")
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
