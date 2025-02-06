//
//  HomeView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isSideMenuOpen = false
    @State private var meetLog: [MeetData] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Title with Side Menu Button
                    TitleModelView(title: "Home", menu: true, isSideMenuOpen: $isSideMenuOpen)
                    
                    List {
                        // Next Meet Countdown Card
                        if let nextMeet = meetLog.first {
                            Section {
                                NextMeetCard(meet: nextMeet)
                            }
                        }
                        
                        // PR Progress Chart Card
                        Section {
                            PRChartCard()
                        }
                        
                        // Workout Summary Card
                        Section {
                            WorkoutSummaryCard()
                        }
                        
                        // Weights Summary Card
                        Section {
                            WeightsSummaryCard()
                        }
                        
                        // Suggested Workouts or Insights or More
                        Section {
                            SuggestedWorkoutsCard()
                        }
                    }
                    .listSectionSpacing(15)
                    
                    // Navigation bar buttons
                    NavigationBar()
                }
                
                // Side Menu
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
            .onAppear {
                loadMeets()
                removePastMeets()
            }
        }
    }
    
    // Load meets from UserDefaults
    private func loadMeets() {
        if let data = UserDefaults.standard.data(forKey: "meetLog"),
           let decoded = try? JSONDecoder().decode([MeetData].self, from: data) {
            meetLog = decoded
        }
    }
    
    // Remove past meets
    private func removePastMeets() {
        meetLog.removeAll { $0.meetDate < Date() }
        saveMeetLog()
    }
    
    // Save updated meet log
    private func saveMeetLog() {
        if let encoded = try? JSONEncoder().encode(meetLog) {
            UserDefaults.standard.set(encoded, forKey: "meetLog")
        }
    }
}

// MARK: - Next Meet Card
struct NextMeetCard: View {
    let meet: MeetData
    
    var body: some View {
        VStack {
            Text("Upcoming Meet")
                .font(.headline)
                .padding(.bottom, 5)
            
            Text("\(daysUntil(meetDate: meet.meetDate)) days until \(meet.meetLocation)")
                .font(.title3)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    private func daysUntil(meetDate: Date) -> Int {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.startOfDay(for: meetDate)
        return calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }
}

// MARK: - PR Chart Card
struct PRChartCard: View {
    @State private var prs = [EventData: String]()
    
    var body: some View {
        VStack {
            Text("PR Progress")
                .font(.headline)
                .padding(.bottom, 5)
            
            // Save and track user PR over lifetime of using the app
            // User can select specific events they have done
            // User can select timeline (past 10 meets, last year, etc.)
            Text("Interactive chart coming soon!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.vertical, 10)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Workout Summary Card
struct WorkoutSummaryCard: View {
    @State private var pastWorkoutData = PastWorkoutData.loadPast()
    
    var sortedPastWorkouts: [WorkoutData] {
        pastWorkoutData.pastWorkouts.sorted(by: { $0.date > $1.date })
    }
    
    var body: some View {
        VStack {
            Text("Today's Workout")
                .font(.headline)
                .padding(.bottom, 5)
            
            // If WorkoutView has been entered
            if let latestWorkout = sortedPastWorkouts.first,
               Calendar.current.startOfDay(for: Date()) == Calendar.current.startOfDay(for: latestWorkout.date) {
                VStack {
                    // If user enters Distance/Reps
                    if latestWorkout.metersString != "" {
                        VStack {
                            Text("Distance/Reps:")
                                .font(.headline)
                                .padding(.bottom, 1)
                            Text("\(latestWorkout.metersString) meters")
                                .font(.subheadline)
                            Text("Sets:")
                                .font(.headline)
                                .padding(.top, 2)
                                .padding(.bottom, 1)
                            Text("\(latestWorkout.sets)")
                                .font(.subheadline)
                        }
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .roundedBackground()
                    // If user enters Time/Reps
                    } else if latestWorkout.timesString != "" {
                        VStack {
                            Text("Time/Reps:")
                                .font(.headline)
                                .padding(.bottom, 1)
                            Text("\(latestWorkout.timesString) seconds")
                                .font(.subheadline)
                            Text("Sets:")
                                .font(.headline)
                                .padding(.top, 2)
                                .padding(.bottom, 1)
                            Text("\(latestWorkout.sets)")
                                .font(.subheadline)
                        }
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .roundedBackground()
                    // If user does nothing
                    } else {
                        NavigationLink {
                            WorkoutView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            HStack {
                                Spacer()
                                Text("No workout logged yet. Tap to log!")
                                    .foregroundStyle(.secondary)
                                    .padding(.vertical, 10)
                                Spacer()
                            }
                        }
                    }
                }
            // No workout logged yet
            } else {
                NavigationLink {
                    WorkoutView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack {
                        Spacer()
                        Text("No workout logged yet. Tap to log!")
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 10)
                        Spacer()
                    }
                }
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Weights Summary Card
struct WeightsSummaryCard: View {
    @State private var weightsData: [WeightExercise] = []
    
    var body: some View {
        VStack {
            Text("Weights Summary")
                .font(.headline)
                .padding(.bottom, 5)
            
            // Filter out default data
            let filteredWeights = weightsData.filter {
                !($0.sets == 1 && $0.weight.allSatisfy { $0.isEmpty } && $0.reps.allSatisfy { $0.isEmpty })
            }
            
            if filteredWeights.isEmpty {
                // No weights data entered yet
                NavigationLink {
                    WeightsView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack {
                        Spacer()
                        Text("No weights logged yet. Tap to log!")
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 10)
                        Spacer()
                    }
                }
            } else {
                // Display the weights data
                ForEach(filteredWeights) { exercise in
                    HStack {
                        Spacer()
                        VStack {
                            Text(exercise.exercise.capitalized)
                                .padding(.bottom, 3)
                                .font(.headline)
                            Text("Sets: \(exercise.sets)")
                                .font(.subheadline)
                            Text("Weight: \(exercise.weight.joined(separator: ", ")) lbs")
                                .font(.subheadline)
                            Text("Reps: \(exercise.reps.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    .roundedBackground()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .onAppear {
            weightsData = WeightsData.loadData()
        }
    }
}

// MARK: - Suggested Workouts Card
struct SuggestedWorkoutsCard: View {
    var body: some View {
        VStack {
            Text("Suggestions")
                .font(.headline)
                .padding(.bottom, 5)
            
            // Takes random suggestion from getSuggestedData
            Text(getSuggestedData(randomInt: Int.random(in: 0..<4)))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .font(.subheadline)
                .roundedBackground()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
