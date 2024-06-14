//
//  HomePageView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/16/24.
//

import SwiftUI

// Other main page for the user, mainly lots of UI and fields
import SwiftUI

struct WorkoutView: View {
    @State private var currDate = Date()
    @State private var currPage: Int = 0
    @State private var isSideMenuOpen = false
    @State private var meters: [String] = [""]
    @State private var numSets = ""
    @State private var isBlocks = false
    @State private var isRecovery = false
    @State private var isOff = false
    @State private var isMeet = false
    @State private var isGrass = false
    @State private var isHills = false
    @State private var isTechnique = false
    @State private var isWorkout = false
    @State private var isTempo = false
    @State private var isFieldModified = false
    @State private var isFocused = false
    @State private var showExperiencePrompt = false
    @State private var selectedExperience: String? = UserDefaults.standard.string(forKey: "SelectedExperience")
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
    private var previousDaysData: [WorkoutData] = []
    var anyToggleOn: Bool {
        isOff || isTechnique || isWorkout || isTempo || isRecovery || isMeet
    }
    
    var body: some View {
        if currPage == 0 {
            ZStack {
                VStack {
                    // Menu bar icon
                    MenuButton(isSideMenuOpen: $isSideMenuOpen)
                    
                    // Display title
                    TitleBackground(title: "Workouts")
                    
                    HStack {
                        // Button to show user's input and recovery suggestions
                        Button(action: {
                            if !isMeet && !isOff && !isRecovery && isDayComplete {
                                withAnimation {
                                    showExperiencePrompt = true
                                }
                            }
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.blue)
                                .frame(width: 50, height: 50)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        // Display current date
                        Text(currDate, formatter: dateFormatter)
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.horizontal, 10)
                        
                        Spacer()
                        
                        // Complete Day button
                        Button(action: {
                            withAnimation {
                                isDayComplete.toggle()
                                isFocused = false
                                if isDayComplete {
                                    withAnimation {
                                        if !isMeet && !isOff && !isRecovery {
                                            showExperiencePrompt = true
                                        }
                                        workoutData?.meters = meters.compactMap { Int($0) }
                                        workoutData?.sets = Int(numSets) ?? 0
                                        workoutData?.blocks = isBlocks
                                        workoutData?.recovery = isRecovery
                                        workoutData?.off = isOff
                                        workoutData?.meet = isMeet
                                        workoutData?.hills = isHills
                                        workoutData?.grass = isGrass
                                        workoutData?.technique = isTechnique
                                        workoutData?.workout = isWorkout
                                        workoutData?.tempo = isTempo
                                        workoutData?.saveData()
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                } else {
                                    selectedExperience = nil
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
                    .sheet(isPresented: $showExperiencePrompt) {
                        if !isMeet && !isOff {
                            RecoveryPrompt(isPresented: $showExperiencePrompt, selectedExperience: $selectedExperience)
                        }
                    }
                    
                    List {
                        Section {
                            VStack {
                                Text("Distance and Reps")
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
                                    withAnimation {
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
                                    get: { numSets },
                                    set: { newValue in
                                        if validateNumberOfRepsInput(newValue) {
                                            numSets = newValue
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
                        
                        Section {
                            VStack(spacing: 15) {
                                HStack {
                                    Spacer()
                                    Text("Day Type")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .padding(.vertical, 10)
                                    Spacer()
                                }
                                
                                ForEach([
                                    ("Off Day", $isOff),
                                    ("Technique Day", $isTechnique),
                                    ("Workout Day", $isWorkout),
                                    ("Tempo Day", $isTempo),
                                    ("Recovery Day", $isRecovery),
                                    ("Meet Day", $isMeet)
                                ], id: \.0) { label, binding in
                                    Toggle(label, isOn: binding)
                                        .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                        .font(.subheadline)
                                        .disabled(isDayComplete || (!binding.wrappedValue && anyToggleOn))
                                        .padding(3)
                                        .roundedBackground()
                                        .padding(.horizontal, 8)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                        .listSectionSpacing(15)
                        .modifier(ToolbarModifier(isFocused: $isFocused))
                        
                        Section {
                            VStack(spacing: 15) {
                                HStack {
                                    Spacer()
                                    
                                    Text("Extras")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .padding(.vertical, 10)
                                    
                                    Spacer()
                                }
                                
                                ForEach([
                                    ("Blocks", $isBlocks),
                                    ("Grass", $isGrass),
                                    ("Hills", $isHills)
                                ], id: \.0) { label, binding in
                                    Toggle(label, isOn: binding)
                                        .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                        .font(.subheadline)
                                        .disabled(isDayComplete)
                                        .padding(3)
                                        .roundedBackground()
                                        .padding(.horizontal, 8)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                        .listSectionSpacing(15)
                        .modifier(ToolbarModifier(isFocused: $isFocused))
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
                        workoutData = WorkoutData(date: Date(), meters: [], sets: 0, blocks: isBlocks, recovery: isRecovery, off: isOff, meet: isMeet, grass: isGrass, hills: isHills, technique: isTechnique, workout: isWorkout, tempo: isTempo, isDayComplete: isDayComplete)
                    }
                    if let loadedData = workoutData?.loadData() {
                        workoutData = loadedData
                        
                        if let workoutData = workoutData {
                            meters = workoutData.meters.isEmpty ? [""] : workoutData.meters.map { String($0) }
                            numSets = workoutData.sets > 0 ? String(workoutData.sets) : ""
                            isBlocks = workoutData.blocks
                            isRecovery = workoutData.recovery
                            isOff = workoutData.off
                            isMeet = workoutData.meet
                            isGrass = workoutData.grass
                            isHills = workoutData.hills
                            isTechnique = workoutData.technique
                            isWorkout = workoutData.workout
                            isTempo = workoutData.tempo
                            isDayComplete = workoutData.isDayComplete
                        }
                    }
                    
                    // Retrieve the state of complete day mode from UserDefaults
                    isDayComplete = UserDefaults.standard.bool(forKey: "isDayComplete")
                    
                    // Reset selectedExperience if it's a new day
                    if let lastExperienceDate = UserDefaults.standard.object(forKey: "lastExperienceDate") as? Date {
                        if !Calendar.current.isDateInToday(lastExperienceDate) {
                            selectedExperience = nil
                            UserDefaults.standard.set(nil, forKey: "SelectedExperience")
                        }
                    } else {
                        selectedExperience = nil
                        UserDefaults.standard.set(nil, forKey: "SelectedExperience")
                    }
                }
                .onDisappear {
                    if workoutData == nil {
                        workoutData = WorkoutData(date: Date(), meters: [], sets: 0, blocks: false, recovery: false, off: false, meet: false, grass: false, hills: false, technique: false, workout: false, tempo: false, isDayComplete: false)
                    } else {
                        isFieldModified = true
                        StreakData.updateStreakIfNeeded(fieldModified: isFieldModified)
                    }
                    workoutData?.meters = meters.compactMap { Int($0) }
                    workoutData?.sets = Int(numSets) ?? 0
                    workoutData?.blocks = isBlocks
                    workoutData?.recovery = isRecovery
                    workoutData?.off = isOff
                    workoutData?.meet = isMeet
                    workoutData?.grass = isGrass
                    workoutData?.hills = isHills
                    workoutData?.technique = isTechnique
                    workoutData?.workout = isWorkout
                    workoutData?.tempo = isTempo
                    workoutData?.isDayComplete = isDayComplete
                    workoutData?.saveData()
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                    // Save the state of complete day mode to UserDefaults
                    UserDefaults.standard.set(isDayComplete, forKey: "isDayComplete")
                    
                    onDisappearAction?(isFieldModified)
                }
                // Show side menu if needed
                SideBar(currPage: $currPage, isSideMenuOpen: $isSideMenuOpen)
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
        } else if currPage == 8 {
            TrainingLogView()
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