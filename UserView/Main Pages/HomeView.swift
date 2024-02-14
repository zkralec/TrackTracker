//
//  HomeView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import SwiftUI

// Main page for the user, shows a variety of info
struct HomeView: View {
    @State private var currentPage: Int = 3
    @State private var selectedEvents: [EventData] = {
    if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
        return savedEvents.compactMap { EventData(rawValue: $0) }
    } else {
        return []
    }
    }()
    @State private var personalRecords = [EventData: String]()
    @State private var meets: [Date] = []
    
    var body: some View {
        if currentPage == 3 {
            VStack {
                // Display title
                TitleBackground(title: "Home")
                
                HStack {
                    // User Info button
                    Button(action: {
                        currentPage = 4
                    }) {
                        HStack {
                            Image(systemName: "gear")
                                .foregroundStyle(.white)
                                .frame(width: 18, height: 18)
                            
                            Text(" Settings")
                                .font(.caption)
                        }
                    }
                    .buttonStyle(CustomButtonStyle())
                    .padding(.bottom)
                }
            }
            
            List {
                // Current streak of tracking workouts
                VStack {
                    Text("Current Streak")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    Text("\(StreakData.streakCount())")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                // User can select main events and add a PR
                VStack {
                    if selectedEvents.isEmpty {
                        Text("No selected events")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        Text("Personal Records")
                            .font(.headline)
                            .fontWeight(.medium)
                            .padding(.bottom, 8)

                        ForEach(selectedEvents, id: \.self) { event in
                            if let record = personalRecords[event], !record.isEmpty {
                                HStack {
                                    Text(event.rawValue)
                                    Spacer()
                                    Text(record)
                                }
                                .padding(.vertical, 4)
                            } else {
                                Text("No personal record set for \(event.rawValue)")
                                    .foregroundColor(.secondary)
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .padding()
                
                VStack {
                    // Display meet dates
                    VStack {
                        Text("Meet Days")
                            .font(.headline)
                            .fontWeight(.medium)
                            .padding()

                        if meets.isEmpty {
                            Text("No meet days selected")
                                .foregroundColor(.secondary)
                                .padding()
                                .roundedBackground()
                        } else {
                            ForEach(meets, id: \.self) { date in
                                Text(date.formatted())
                                    .padding(5)
                                    .roundedBackground()
                            }
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .onAppear {
                    loadPR()
                    loadMeets()
                }
                .padding()
            }
            .listStyle(PlainListStyle())
            .background(Color.gray.opacity(0.05))
            
            // Navigation buttons
            HStack {
                VStack {
                    // Exercise button
                    Button(action: {
                        currentPage = 1
                    }) {
                        Image(systemName: "dumbbell.fill")
                            .foregroundStyle(.white)
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .frame(width: 120, height: 40)
                    
                    Text("Exercises")
                        .font(.caption)
                        .foregroundStyle(.blue)
                        .padding(4)
                }
                
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
            
        } else if currentPage == 4 {
            SettingsView()
        } else if currentPage == 0 {
            WorkoutView()
        } else if currentPage == 1 {
            ExerciseView()
        } else if currentPage == 2 {
            MealsView()
        }
    }
    
    // Load in the current meet dates
    func loadMeets() {
        if let data = UserDefaults.standard.data(forKey: "meetDates") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Date].self, from: data) {
                meets = decoded
            }
        }
    }
    
    // Load the user's event PRs
    func loadPR() {
        for event in selectedEvents {
            if let prValue = UserDefaults.standard.string(forKey: event.rawValue) {
                personalRecords[event] = prValue
            }
        }
    }
}

#Preview {
    HomeView()
}
