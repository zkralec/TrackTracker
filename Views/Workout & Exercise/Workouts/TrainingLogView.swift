//
//  TrainingLogView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/27/24.
//

import SwiftUI

// Keeps track of the last 10 workouts a user completed
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
                                Section {
                                    // If meet or off, use simplified formatting
                                    if workout.meet {
                                        Text("Date: \(workout.formattedDate)")
                                        Text("Meet Day")
                                            .font(.title3)
                                    } else if workout.off {
                                        Text("Date: \(workout.formattedDate)")
                                        Text("Off Day")
                                            .font(.title3)
                                    } else if workout.injury {
                                        Text("Date: \(workout.formattedDate)")
                                        Text("Injured")
                                            .font(.title3)
                                    // Else, format to show all relevant information with Extras section
                                    } else {
                                        Text("Date: \(workout.formattedDate)")
                                        if workout.technique {
                                            Text("Practice Type: Technique Day")
                                        } else if workout.workout {
                                            Text("Practice Type: Workout Day")
                                        } else if workout.tempo {
                                            Text("Practice Type: Tempo Day")
                                        } else if workout.recovery {
                                            Text("Practice Type: Recovery Day")
                                        }
                                        VStack(alignment: .leading) {
                                            if workout.metersString != "" {
                                                Text("Distance/Reps: (\(workout.metersString)) meters")
                                            } else if workout.timesString != "" {
                                                Text("Time/Reps: (\(workout.timesString)) seconds")
                                            } else {
                                                Text("Distance/Time/Reps: None")
                                            }
                                            Text("Sets: \(workout.sets)")
                                                .padding(.top,3)
                                        }
                                        // Extras section
                                        DisclosureGroup("Extra Info.") {
                                            // Surfaces
                                            ForEach([
                                                (key: "Track", value: workout.track),
                                                (key: "Indoor Track", value: workout.indoorTrack),
                                                (key: "Turf", value: workout.turf),
                                                (key: "Dirt", value: workout.dirt),
                                                (key: "Grass/Hills", value: workout.grasshills),
                                                (key: "Asphalt", value: workout.asphalt)
                                            ], id: \.key) { surface in
                                                if surface.value {
                                                    Text("Surface: \(surface.key)")
                                                }
                                            }
                                            // Weather
                                            let weatherOptions = [
                                                (key: "Rain", value: workout.rain),
                                                (key: "Snow", value: workout.snow),
                                                (key: "Windy", value: workout.windy),
                                                (key: "Normal", value: workout.normal),
                                                (key: "Hot", value: workout.hot),
                                                (key: "Cold", value: workout.cold)
                                            ]
                                            let selectedWeather = weatherOptions.filter { $0.value }.map { $0.key }.joined(separator: ", ")
                                            if selectedWeather != "" {
                                                Text("Weather: \(selectedWeather)")
                                            }
                                            // Equipment
                                            let equipmentOptions = [
                                                (key: "Blocks", value: workout.blocks),
                                                (key: "Resistance Band", value: workout.resistanceBand),
                                                (key: "Weights", value: workout.weights),
                                                (key: "Sled", value: workout.sled),
                                                (key: "Hurdles", value: workout.hurdles),
                                                (key: "Weighted Vest", value: workout.weightedVest),
                                                (key: "Plyo Box", value: workout.plyoBox),
                                                (key: "Medicine Ball", value: workout.medicineBall),
                                                (key: "Stationary Bike", value: workout.stationaryBike),
                                                (key: "Treadmill", value: workout.treadmill)
                                            ]
                                            let selectedEquipment = equipmentOptions.filter { $0.value }.map { $0.key }.joined(separator: ", ")
                                            if selectedEquipment != "" {
                                                Text("Equipment: \(selectedEquipment)")
                                            }
                                            // Condition
                                            ForEach([
                                                (key: "Injury", value: workout.injury),
                                                (key: "Soreness", value: workout.soreness),
                                                (key: "Fatigued", value: workout.fatigued),
                                                (key: "Peak Form", value: workout.peakForm)
                                            ], id: \.key) { condition in
                                                if condition.value {
                                                    Text("Condition: \(condition.key)")
                                                }
                                            }
                                            // Intensity
                                            ForEach([
                                                (key: "Low", value: workout.low),
                                                (key: "Moderate", value: workout.moderate),
                                                (key: "High", value: workout.high),
                                                (key: "Maximum", value: workout.maximum)
                                            ], id: \.key) { intensity in
                                                if intensity.value {
                                                    Text("Intensity: \(intensity.key)")
                                                }
                                            }
                                            // Field events
                                            let eventOptions = [
                                                (key: "High Jump", value: workout.highJump),
                                                (key: "Pole Vault", value: workout.poleVault),
                                                (key: "Hammer Throw", value: workout.hammerThrow),
                                                (key: "Discus", value: workout.discus),
                                                (key: "Shot Put", value: workout.shotPut),
                                                (key: "Javelin", value: workout.javelin),
                                                (key: "Long Jump", value: workout.longJump),
                                                (key: "Triple Jump", value: workout.tripleJump)
                                            ]
                                            let selectedEvent = eventOptions.filter { $0.value }.map { $0.key }.joined(separator: ", ")
                                            if selectedEvent != "" {
                                                Text("Event(s) Practiced: \(selectedEvent)")
                                            }
                                        }
                                    }
                                }
                                .listSectionSpacing(15)
                            }
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
        } else if currPage == 6 {
            MeetView()
        } else if currPage == 7 {
            ProfileView()
        } else if currPage == 9 {
            InjuryView()
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

