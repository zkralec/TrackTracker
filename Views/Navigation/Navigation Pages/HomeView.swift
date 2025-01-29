//
//  HomeView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isSideMenuOpen = false
    @State private var prs = [EventData: String]()
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
                            PRChartCard(prs: prs)
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
    let prs: [EventData: String]
    
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
            
            if let latestWorkout = sortedPastWorkouts.first,
               Calendar.current.startOfDay(for: Date()) == Calendar.current.startOfDay(for: latestWorkout.date) {
                // Display workout details
                VStack {
                    if latestWorkout.metersString != "" {
                        Text("**Distance/Reps:** \(latestWorkout.metersString) meters")
                            .multilineTextAlignment(.center)
                    } else if latestWorkout.timesString != "" {
                        Text("**Time/Reps:** \(latestWorkout.timesString) seconds")
                            .multilineTextAlignment(.center)
                    } else {
                        NavigationLink {
                            WorkoutView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            HStack {
                                Spacer()
                                
                                Text("No workout logged yet. Tap to log!")
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                            }
                        }
                    }
                    if latestWorkout.sets > 0 {
                        Text("**Sets:** \(latestWorkout.sets)")
                            .padding(.top, 3)
                    }
                }
                .padding(.vertical, 10)
            } else {
                // No workout logged yet
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
    @State private var weightsData = WeightsData.loadData()
    
    var body: some View {
        VStack {
            Text("Weights Summary")
                .font(.headline)
                .padding(.bottom, 5)
            
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
        }
        .padding()
        .frame(maxWidth: .infinity)
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
                .font(.subheadline)
                .padding(.vertical, 10)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
