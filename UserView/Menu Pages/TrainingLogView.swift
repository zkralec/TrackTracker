//
//  TrainingLogView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/27/24.
//

import SwiftUI

struct TrainingLogView: View {
    @State private var currPage: Int = 8
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
        if currPage == 8 {
            ZStack {
                VStack {
                    // Menu bar icon
                    MenuButton(isSideMenuOpen: $isSideMenuOpen)
                    
                    // Title
                    TitleBackground(title: "Training Log")
                    
                    // Display past 10 day history of workouts
                    List {
                        ForEach(sortedPastWorkouts, id: \.self) { workout in
                            Section {
                                if workout.meet {
                                    Text("Date: \(workout.formattedDate)")
                                    Text("Meet Day")
                                        .font(.title3)
                                } else if workout.off {
                                    Text("Date: \(workout.formattedDate)")
                                    Text("Off Day")
                                        .font(.title3)
                                } else {
                                    Text("Date: \(workout.formattedDate)")
                                    VStack(alignment: .leading) {
                                        Text("Meters: \(workout.metersString)")
                                        Text("Sets: \(workout.sets)")
                                        Text("Blocks: \(workout.blocks ? "Yes" : "No")")
                                        Text("Recovery: \(workout.recovery ? "Yes" : "No")")
                                        Text("Off Day: \(workout.off ? "Yes" : "No")")
                                        Text("Meet Day: \(workout.meet ? "Yes" : "No")")
                                        Text("Grass: \(workout.grass ? "Yes" : "No")")
                                        Text("Hills: \(workout.hills ? "Yes" : "No")")
                                    }
                                }
                            }
                            .listSectionSpacing(15)
                        }
                    }
                    .background(Color.gray.opacity(0.05))
                }
                // Show side menu if needed
                SideBar(currPage: $currPage, isSideMenuOpen: $isSideMenuOpen)
            }
        } else if currPage == 3 {
            HomeView()
        } else if currPage == 4 {
            SettingsView()
        } else if currPage == 5 {
            EventView(events: $events)
        } else if currPage == 7 {
            ProfileView()
        }
    }
}

extension WorkoutData {
    var metersString: String {
        return meters.map { "\($0)" }.joined(separator: ", ")
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

#Preview {
    TrainingLogView()
}
