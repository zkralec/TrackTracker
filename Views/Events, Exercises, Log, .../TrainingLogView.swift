//
//  TrainingLogView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/27/24.
//

import SwiftUI

// Keeps track of the last 10 workouts a user completed
struct TrainingLogView: View {
    @State private var isSideMenuOpen = false
    @State private var pastWorkoutData = PastWorkoutData.loadPast()
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    var sortedPastWorkouts: [WorkoutData] {
        pastWorkoutData.pastWorkouts.sorted(by: { $0.date > $1.date })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        ZStack {
                            // Display title
                            TitleBackground(title: "Training Log")
                            
                            HStack {
                                // Menu bar icon
                                MenuButton(isSideMenuOpen: $isSideMenuOpen)
                                Spacer()
                            }
                        }
                        Divider()
                    }
                    .padding(.bottom, -8)
                    
                    // Display past 10 day history of workouts
                    List {
                        if sortedPastWorkouts.isEmpty {
                            Section {
                                HStack {
                                    Spacer()
                                    
                                    Text("No past workout data")
                                        .fontWeight(.medium)
                                        .font(.title3)
                                    
                                    Spacer()
                                }
                            }
                        }
                        else {
                            ForEach(sortedPastWorkouts, id: \.self) { workout in
                                Section(workout.formattedDate) {
                                    VStack(alignment: .leading) {
                                        if workout.metersString != "" {
                                            Text("Distance/Reps: (\(workout.metersString)) meters")
                                        } else if workout.timesString != "" {
                                            Text("Time/Reps: (\(workout.timesString)) seconds")
                                        } else {
                                            Text("Distance/Time/Reps: None")
                                        }
                                        if workout.sets == 0 {
                                            Text("Sets: None")
                                                .padding(.top, 3)
                                        } else {
                                            Text("Sets: \(workout.sets)")
                                                .padding(.top, 3)
                                        }
                                    }
                                }
                                .listSectionSpacing(15)
                            }
                        }
                    }
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
}

extension WorkoutData {
    var metersString: String {
        return meters.map { "\($0)" }.joined(separator: ", ")
    }
    
    var timesString: String {
        return times.map { "\($0)" }.joined(separator: ", ")
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

