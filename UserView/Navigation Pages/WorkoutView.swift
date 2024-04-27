//
//  HomePageView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/16/24.
//

import SwiftUI

// Other main page for the user, mainly lots of UI and fields
struct WorkoutView: View {
    @State private var currDate = Date()
    @State private var currPage: Int = 0
    @State private var isSideMenuOpen = false
    @State private var meters: [String] = [""]
    @State private var numReps = ""
    @State private var isBlocks = false
    @State private var isRecovery = false
    @State private var isGrass = false
    @State private var isHills = false
    @State private var isFieldModified = false
    @State private var isFocused = false
    @State private var workoutData: WorkoutData?
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    @AppStorage("isDayComplete") private var isDayComplete = false
    
    var onDisappearAction: ((Bool) -> Void)?
    
    var body: some View {
        if currPage == 0 {
            VStack {
                // Menu bar icon
                MenuBar(isSideMenuOpen: $isSideMenuOpen)
                
                // Display title
                TitleBackground(title: "Workouts")
                
                HStack {
                    // Display current date
                    Text(currDate, formatter: dateFormatter)
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.leading, 150)
                    
                    Spacer()
                    
                    // Complete Day button
                    Button(action: {
                        withAnimation {
                            isDayComplete.toggle()
                            isFocused = false
                            if isDayComplete {
                                workoutData?.meters = meters.compactMap { Int($0) }
                                workoutData?.reps = Int(numReps) ?? 0
                                workoutData?.blocks = isBlocks
                                workoutData?.recovery = isRecovery
                                workoutData?.hills = isHills
                                workoutData?.grass = isGrass
                                workoutData?.saveData()
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }
                    }) {
                        if !isDayComplete {
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(.blue)
                                .frame(width: 50, height: 50)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.blue)
                                .frame(width: 50, height: 50)
                        }
                    }
                    .padding(.trailing, 20)
                }
                
                List {
                    Section {
                        VStack {
                            Text("Reps Ran")
                                .font(.headline)
                                .fontWeight(.medium)
                                .padding(10)
                            
                            // Creates meter fields for user input
                            VStack() {
                                ForEach(0..<meters.count, id: \.self) { index in
                                    TextField("Meters", text: Binding(
                                        get: { meters[index] },
                                        set: { newValue in
                                            meters[index] = newValue
                                        }
                                    ))
                                    .keyboardType(.numberPad)
                                    .padding(10)
                                    .disabled(isDayComplete)
                                    .onTapGesture {
                                        self.isFocused = true
                                    }
                                    .roundedBackground()
                                }
                            }
                            
                            // Buttons to add or remove reps
                            if !isDayComplete {
                                HStack {
                                    VStack {
                                        Button(action: {
                                            if meters.count < 5 {
                                                meters.append("")
                                            }
                                        }) {
                                            Image(systemName: "plus")
                                                .foregroundStyle(.white)
                                                .frame(width: 30, height: 10)
                                        }
                                        .padding(.top, 8)
                                        .buttonStyle(CustomButtonStyle())
                                        
                                        Text("Add")
                                            .font(.caption)
                                            .foregroundStyle(.blue)
                                            .padding(4)
                                    }
                                    
                                    VStack {
                                        Button(action: {
                                            if meters.count > 1 {
                                                meters.removeLast()
                                            }
                                        }) {
                                            Image(systemName: "minus")
                                                .foregroundStyle(.white)
                                                .frame(width: 30, height: 10)
                                        }
                                        .padding(.top, 8)
                                        .buttonStyle(CustomButtonStyle())
                                        
                                        Text("Remove")
                                            .font(.caption)
                                            .foregroundStyle(.blue)
                                            .padding(4)
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(.bottom, -10)
                            }
                        }
                    }
                    .padding(.bottom, 5)
                    .listSectionSpacing(15)
                    
                    // Sets field
                    Section {
                        VStack {
                            HStack {
                                Spacer()
                                
                                Text("Sets")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .padding(10)
                                
                                Spacer()
                            }
                            
                            TextField("Number of Sets", text: Binding(
                                get: { numReps },
                                set: { newValue in
                                    if validateNumberOfRepsInput(newValue) {
                                        numReps = newValue
                                    }
                                }
                            ))
                            .keyboardType(.numberPad)
                            .padding(10)
                            .disabled(isDayComplete)
                            .onTapGesture {
                                self.isFocused = true
                            }
                            .roundedBackground()
                        }
                    }
                    .padding(.bottom, 5)
                    .listSectionSpacing(15)
                    
                    // Toggles
                    Section {
                        VStack {
                            HStack {
                                Spacer()
                                
                                Text("Extras")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .padding(10)
                                
                                Spacer()
                            }
                            
                            HStack {
                                //Toggle for Blocks
                                Toggle("Blocks", isOn: $isBlocks)
                                    .font(.subheadline)
                                    .disabled(isDayComplete)
                                    .roundedBackground()
                                
                                // Toggle for Recovery day
                                Toggle("Recovery", isOn: $isRecovery)
                                    .font(.subheadline)
                                    .disabled(isDayComplete)
                                    .roundedBackground()
                            }
                            .padding(.top, 15)
                            .padding(.horizontal, 8)
                            
                            HStack {
                                //Toggle for grass
                                Toggle("Grass", isOn: $isGrass)
                                    .font(.subheadline)
                                    .disabled(isDayComplete)
                                    .roundedBackground()
                                
                                // Toggle for hills
                                Toggle("Hills", isOn: $isHills)
                                    .font(.subheadline)
                                    .disabled(isDayComplete)
                                    .roundedBackground()
                            }
                            .padding(.top, 8)
                            .padding(.horizontal, 8)
                        }
                    }
                    .padding(.bottom, 5)
                    .listSectionSpacing(15)
                }
                .modifier(ToolbarModifier(isFocused: $isFocused))
                .background(Color.gray.opacity(0.05))
                
                // Show side menu if needed
                if isSideMenuOpen {
                    SideBar(currPage: $currPage, isSideMenuOpen: $isSideMenuOpen)
                }
                
                // Navigation bar buttons
                if !isFocused {
                    VStack {
                        NavigationBar(currPage: $currPage)
                    }
                }
            }
            .onAppear {
                // Update the empty storage before loading data
                WorkoutData.updateDataAtStartOfDay(currentDate: currDate)
                
                // Load workout data
                if workoutData == nil {
                    workoutData = WorkoutData(date: Date(), meters: [], reps: 0, blocks: isBlocks, recovery: isRecovery, grass: isGrass, hills: isHills, isDayComplete: isDayComplete)
                }
                if let loadedData = workoutData?.loadData() {
                    workoutData = loadedData
                    
                    if let workoutData = workoutData {
                        meters = workoutData.meters.isEmpty ? [""] : workoutData.meters.map { String($0) }
                        numReps = workoutData.reps > 0 ? String(workoutData.reps) : ""
                        isBlocks = workoutData.blocks
                        isRecovery = workoutData.recovery
                        isGrass = workoutData.grass
                        isHills = workoutData.hills
                        isDayComplete = workoutData.isDayComplete
                    }
                }
                
                // Retrieve the state of complete day mode from UserDefaults
                isDayComplete = UserDefaults.standard.bool(forKey: "isDayComplete")
            }
            .onDisappear {
                if workoutData == nil {
                    workoutData = WorkoutData(date: Date(), meters: [], reps: 0, blocks: false, recovery: false, grass: false, hills: false, isDayComplete: false)
                } else {
                    isFieldModified = true
                    StreakData.updateStreakIfNeeded(fieldModified: isFieldModified)
                    
                }
                workoutData?.meters = meters.compactMap { Int($0) }
                workoutData?.reps = Int(numReps) ?? 0
                workoutData?.blocks = isBlocks
                workoutData?.recovery = isRecovery
                workoutData?.grass = isGrass
                workoutData?.hills = isHills
                workoutData?.isDayComplete = isDayComplete
                workoutData?.saveData()
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
                // Save the state of complete day mode to UserDefaults
                UserDefaults.standard.set(isDayComplete, forKey: "isDayComplete")
                
                onDisappearAction?(isFieldModified)
            }
        } else if currPage == 7 {
            ProfileView()
        } else if currPage == 1 {
            ExerciseView()
        } else if currPage == 2 {
            MealsView()
        } else if currPage == 3 {
            HomeView()
        } else if currPage == 4 {
            SettingsView()
        } else if currPage == 5 {
            EventView(events: $events)
        } else if currPage == 6 {
            MeetView()
        }
    }
    
    // Function to validate the input for meters
    private func validateMetersInput(_ value: String) -> Bool {
        guard let intValue = Int(value) else { return false }
        return intValue <= 10_000
    }
    
    // Function to validate the input for the number of reps
    private func validateNumberOfRepsInput(_ value: String) -> Bool {
        guard let intValue = Int(value) else { return false }
        return intValue <= 100
    }
}

// Extension providing a date formatter
extension WorkoutView {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

#Preview {
    WorkoutView()
}
