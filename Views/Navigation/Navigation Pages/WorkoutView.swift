//
//  HomePageView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/16/24.
//

import SwiftUI
import UIKit

// Other main page for the user, mainly lots of UI and fields
struct WorkoutView: View {
    @State private var currDate = Date()
    @State private var isSideMenuOpen = false
    @State private var meters: [String] = [""]
    @State private var times: [String] = [""]
    @State private var numSets = ""
    @State private var isFieldModified = false
    @State private var isFocused = false
    @State private var showRecoverySuggestions = false
    @State private var selectedExperience: String? = UserDefaults.standard.string(forKey: "SelectedExperience")
    @State private var isDistanceMode: Bool
    @State private var workoutData: WorkoutData?
    @ObservedObject var settings = SettingsViewModel()
    
    @State private var isRecovery = false
    @State private var isOff = false
    @State private var isMeet = false
    @State private var isHills = false
    @State private var isTechnique = false
    @State private var isWorkout = false
    @State private var isTempo = false
    
    @State private var isTrack = false
    @State private var isIndoorTrack = false
    @State private var isTurf = false
    @State private var isDirt = false
    @State private var isGrassHills = false
    @State private var isAsphalt = false
    
    @State private var isRain = false
    @State private var isSnow = false
    @State private var isWindy = false
    @State private var isNormal = false
    @State private var isHot = false
    @State private var isCold = false
    
    @State private var isBlocks = false
    @State private var isResistanceBand = false
    @State private var isWeights = false
    @State private var isSled = false
    @State private var isWickets = false
    @State private var isHurdles = false
    @State private var isWeightedVest = false
    @State private var isPlyoBox = false
    @State private var isMedicineBall = false
    @State private var isStationaryBike = false
    @State private var isTreadmill = false
    
    @State private var isInjury = false
    @State private var isSoreness = false
    @State private var isFatigued = false
    @State private var isPeakForm = false
    
    @State private var isLow = false
    @State private var isModerate = false
    @State private var isHigh = false
    @State private var isMaximum = false
    
    @State private var isHighJump = false
    @State private var isPoleVault = false
    @State private var isHammerThrow = false
    @State private var isDiscus = false
    @State private var isShotPut = false
    @State private var isJavelin = false
    @State private var isLongJump = false
    @State private var isTripleJump = false
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    // Have the meters or times field appear depending on saved values
    init() {
        // Safely unwrap the optional data returned by WorkoutData.loadData()
        if let workoutData = WorkoutData.loadData() {
            let hasTimes = !workoutData.times.isEmpty
            let hasMeters = !workoutData.meters.isEmpty
            
            if !hasTimes && hasMeters {
                isDistanceMode = true
            } else if hasTimes && !hasMeters {
                isDistanceMode = false
            } else if !hasTimes && !hasMeters {
                isDistanceMode = true
            } else {
                isDistanceMode = true
            }
        } else {
            isDistanceMode = true
        }
    }
    
    @FocusState private var focusedField: Int?
    @AppStorage("isDayComplete") private var isDayComplete = false
    
    var onDisappearAction: ((Bool) -> Void)?
    private var previousDaysData: [WorkoutData] = []
    
    // Will disable toggles in section after one is toggled
    var anyDayToggleOn: Bool {
        isOff || isTechnique || isWorkout || isTempo || isRecovery || isMeet
    }
    var anySurfaceToggleOn: Bool {
        isTrack || isIndoorTrack || isDirt || isGrassHills || isAsphalt
    }
    var anyConditionToggleOn: Bool {
        isInjury || isSoreness || isFatigued || isPeakForm
    }
    var anyIntensityToggleOn: Bool {
        isLow || isModerate || isHigh || isMaximum
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        ZStack {
                            // Display title
                            TitleBackground(title: "Workouts")
                            
                            HStack {
                                // Menu bar icon
                                MenuButton(isSideMenuOpen: $isSideMenuOpen)
                                Spacer()
                            }
                        }
                        
                        HStack {
                            // Button to show user's input and recovery suggestions
                            Button(action: {
                                if !isMeet && !isOff && !isRecovery && !isInjury && isDayComplete {
                                    withAnimation {
                                        showRecoverySuggestions = true
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
                                        if !isMeet && !isOff && !isRecovery {
                                            showRecoverySuggestions = true
                                            // Schedules recovery notification
                                            scheduleNotification(for: currDate)
                                        }
                                        workoutData?.meters = meters.compactMap { Int($0) }
                                        workoutData?.times = times.compactMap { Int($0) }
                                        workoutData?.sets = Int(numSets) ?? 0
                                        
                                        workoutData?.recovery = isRecovery
                                        workoutData?.off = isOff
                                        workoutData?.meet = isMeet
                                        workoutData?.technique = isTechnique
                                        workoutData?.workout = isWorkout
                                        workoutData?.tempo = isTempo
                                        
                                        workoutData?.dayComplete = isDayComplete
                                        
                                        workoutData?.track = isTrack
                                        workoutData?.indoorTrack = isIndoorTrack
                                        workoutData?.turf = isTurf
                                        workoutData?.dirt = isDirt
                                        workoutData?.grasshills = isGrassHills
                                        workoutData?.asphalt = isAsphalt
                                        
                                        workoutData?.rain = isRain
                                        workoutData?.snow = isSnow
                                        workoutData?.windy = isWindy
                                        workoutData?.normal = isNormal
                                        workoutData?.hot = isHot
                                        workoutData?.cold = isCold
                                        
                                        workoutData?.blocks = isBlocks
                                        workoutData?.resistanceBand = isResistanceBand
                                        workoutData?.weights = isWeights
                                        workoutData?.sled = isSled
                                        workoutData?.wickets = isWickets
                                        workoutData?.hurdles = isHurdles
                                        workoutData?.weightedVest = isWeightedVest
                                        workoutData?.plyoBox = isPlyoBox
                                        workoutData?.medicineBall = isMedicineBall
                                        workoutData?.stationaryBike = isStationaryBike
                                        workoutData?.treadmill = isTreadmill
                                        
                                        workoutData?.injury = isInjury
                                        workoutData?.soreness = isSoreness
                                        workoutData?.fatigued = isFatigued
                                        workoutData?.peakForm = isPeakForm
                                        
                                        workoutData?.low = isLow
                                        workoutData?.moderate = isModerate
                                        workoutData?.high = isHigh
                                        workoutData?.maximum = isMaximum
                                        
                                        workoutData?.highJump = isHighJump
                                        workoutData?.poleVault = isPoleVault
                                        workoutData?.hammerThrow = isHammerThrow
                                        workoutData?.discus = isDiscus
                                        workoutData?.shotPut = isShotPut
                                        workoutData?.javelin = isJavelin
                                        workoutData?.longJump = isLongJump
                                        workoutData?.tripleJump = isTripleJump
                                        
                                        workoutData?.saveData()
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    } else {
                                        selectedExperience = nil
                                    }
                                    // Feature to enable or disable haptics
                                    if settings.isHapticsEnabled {
                                        let generator = UIImpactFeedbackGenerator(style: .light)
                                        generator.impactOccurred()
                                    }
                                }
                            }) {
                                // Is day complete button
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
                        Divider()
                    }
                    .padding(.bottom, -8)
                    // Once day is complete, prompt user with recovery page if needed
                    .sheet(isPresented: $showRecoverySuggestions) {
                        if !isMeet && !isOff {
                            RecoveryPrompt(isPresented: $showRecoverySuggestions, selectedExperience: $selectedExperience)
                        }
                    }
                    
                    // List for all the user input fields and toggles
                    List {
                        Section(isDistanceMode ? "Distance and Reps" : "Time and Reps") {
                            VStack {
                                // Toggle between distance and time
                                Picker("Mode", selection: $isDistanceMode) {
                                    Text("Distance").tag(true)
                                    Text("Time").tag(false)
                                }
                                .disabled(isDayComplete)
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.bottom, 10)
                                
                                // Creates meter or time fields for user input
                                VStack {
                                    // Distance fields
                                    if isDistanceMode {
                                        ForEach(0..<meters.count, id: \.self) { index in
                                            TextField("Meters", text: Binding(
                                                get: { meters[index] },
                                                set: { newValue in
                                                    if validateMetersInput(newValue) {
                                                        meters[index] = newValue
                                                    }
                                                }
                                            ))
                                            .keyboardType(.numberPad)
                                            .padding(10)
                                            .disabled(isDayComplete)
                                            .focused($focusedField, equals: index)
                                            .contentShape(Rectangle())
                                            .highPriorityGesture(
                                                TapGesture().onEnded {
                                                    withAnimation {
                                                        isFocused = true
                                                        focusedField = index
                                                    }
                                                }
                                            )
                                            .roundedBackground()
                                        }
                                    } else {
                                        // Times fields
                                        ForEach(0..<times.count, id: \.self) { index in
                                            TextField("Seconds", text: Binding(
                                                get: { times[index] },
                                                set: { newValue in
                                                    if validateTimeInput(newValue) {
                                                        times[index] = newValue
                                                    }
                                                }
                                            ))
                                            .keyboardType(.numberPad)
                                            .padding(10)
                                            .disabled(isDayComplete)
                                            .focused($focusedField, equals: index)
                                            .contentShape(Rectangle())
                                            .highPriorityGesture(
                                                TapGesture().onEnded {
                                                    withAnimation {
                                                        isFocused = true
                                                        focusedField = index
                                                    }
                                                }
                                            )
                                            .roundedBackground()
                                        }
                                    }
                                }
                                
                                // Change style to bottom left of section (stepper like style?)
                                // Add/Remove buttons for reps
                                if !isDayComplete {
                                    HStack {
                                        Button(action: {
                                            if isDistanceMode && meters.count > 1 {
                                                meters.removeLast()
                                            } else if !isDistanceMode && times.count > 1 {
                                                times.removeLast()
                                            }
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .foregroundStyle(.blue)
                                                .frame(width: 30, height: 30)
                                        }
                                        .padding(.trailing)
                                        .buttonStyle(BorderlessButtonStyle())
                                        
                                        Button(action: {
                                            if isDistanceMode && meters.count < 10 {
                                                meters.append("")
                                            } else if !isDistanceMode && times.count < 10 {
                                                times.append("")
                                            }
                                        }) {
                                            Image(systemName: "plus.circle")
                                                .foregroundStyle(.blue)
                                                .frame(width: 30, height: 30)
                                        }
                                        .padding(.leading)
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    .roundedBackground()
                                    .padding(.top)
                                }
                            }
                            .padding()
                        }
                        
                        // Sets field
                        Section("Sets") {
                            // Input field for sets
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
                            .focused($focusedField, equals: 200)
                            // This fixes iOS 18 bug that was introduced
                            .highPriorityGesture(
                                TapGesture().onEnded {
                                    withAnimation {
                                        isFocused = true
                                        focusedField = 200
                                    }
                                })
                            .roundedBackground()
                            .padding()
                        }
                        
                        if !isDayComplete {
                            Section("Extra") {
                                DisclosureGroup("Extra Selections") {
                                    // Section for the training or day type
                                    Section {
                                        WorkoutTogglesView(
                                            sectionTitle: "Workout Type",
                                            toggles: [
                                                ("Off Day", $isOff),
                                                ("Technique Day", $isTechnique),
                                                ("Workout Day", $isWorkout),
                                                ("Tempo Day", $isTempo),
                                                ("Recovery Day", $isRecovery),
                                                ("Meet Day", $isMeet)
                                            ],
                                            isDisabled: isDayComplete || anyDayToggleOn
                                        )
                                    }
                                    
                                    // Intensity Section
                                    Section {
                                        WorkoutTogglesView(
                                            sectionTitle: "Intensity",
                                            toggles: [
                                                ("Low", $isLow),
                                                ("Moderate", $isModerate),
                                                ("High", $isHigh),
                                                ("Maximum", $isMaximum)
                                            ],
                                            isDisabled: isDayComplete || anyIntensityToggleOn
                                        )
                                    }
                                    
                                    // Equipment Section
                                    Section {
                                        WorkoutTogglesView(
                                            sectionTitle: "Equipment",
                                            toggles: [
                                                ("Blocks", $isBlocks),
                                                ("Resistance Band", $isResistanceBand),
                                                ("Weights", $isWeights),
                                                ("Sled", $isSled),
                                                ("Wickets", $isWickets),
                                                ("Hurdles", $isHurdles),
                                                ("Weighted Vest", $isWeightedVest),
                                                ("Plyo Box", $isPlyoBox),
                                                ("Medicine Ball", $isMedicineBall),
                                                ("Stationary Bike", $isStationaryBike),
                                                ("Treadmill", $isTreadmill)
                                            ],
                                            isDisabled: isDayComplete
                                        )
                                    }
                                    
                                    // Surface Section
                                    Section {
                                        WorkoutTogglesView(
                                            sectionTitle: "Surface Type",
                                            toggles: [
                                                ("Outdoor Track", $isTrack),
                                                ("Indoor Track", $isIndoorTrack),
                                                ("Turf", $isTurf),
                                                ("Dirt", $isDirt),
                                                ("Grass/Hills", $isGrassHills),
                                                ("Asphalt", $isAsphalt)
                                            ],
                                            isDisabled: isDayComplete || anySurfaceToggleOn
                                        )
                                    }
                                    
                                    // Condition Section
                                    Section {
                                        WorkoutTogglesView(
                                            sectionTitle: "Condition",
                                            toggles: [
                                                ("Injury", $isInjury),
                                                ("Soreness", $isSoreness),
                                                ("Fatigued", $isFatigued),
                                                ("Peak Form", $isPeakForm)
                                            ],
                                            isDisabled: isDayComplete || anyConditionToggleOn
                                        )
                                    }
                                    
                                    // Weather Section
                                    Section {
                                        WorkoutTogglesView(
                                            sectionTitle: "Weather",
                                            toggles: [
                                                ("Rain", $isRain),
                                                ("Snow", $isSnow),
                                                ("Windy", $isWindy),
                                                ("Normal", $isNormal),
                                                ("Hot", $isHot),
                                                ("Cold", $isCold)
                                            ],
                                            isDisabled: isDayComplete
                                        )
                                    }
                                    
                                    // Field Events Section
                                    Section {
                                        WorkoutTogglesView(
                                            sectionTitle: "Field Events",
                                            toggles: [
                                                ("High Jump", $isHighJump),
                                                ("Pole Vault", $isPoleVault),
                                                ("Hammer Throw", $isHammerThrow),
                                                ("Discus", $isDiscus),
                                                ("Shot Put", $isShotPut),
                                                ("Javelin", $isJavelin),
                                                ("Long Jump", $isLongJump),
                                                ("Triple Jump", $isTripleJump)
                                            ],
                                            isDisabled: isDayComplete
                                        )
                                    }
                                }
                            }
                        } else {
                            // Let user know how to get toggles back
                            Section("Misc.") {
                                Text("If toggles need to be modified, make sure day is not complete.")
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                        }
                    }
                    .listSectionSpacing(10)
                    .modifier(ToolbarModifier(isFocused: $isFocused))
                    
                    // Navigation bar buttons
                    if !isFocused {
                        NavigationBar()
                    }
                }
                .onAppear {
                    // Only use when adding new vars to be saved
                    // WorkoutData.clearAllData()
                    
                    // Will reset the day completion if necessary
                    resetDayCompletionIfNeeded()
                    
                    // Update the empty storage before loading data
                    WorkoutData.updateDataAtStartOfDay(currentDate: currDate)
                    
                    // Load workout data if available
                    if let loadedData = WorkoutData.loadData() {
                        workoutData = loadedData
                        
                        // Update UI state with loaded data
                        if let workoutData = workoutData {
                            meters = workoutData.meters.isEmpty ? [""] : workoutData.meters.map { String($0) }
                            times = workoutData.times.isEmpty ? [""] : workoutData.times.map { String($0) }
                            numSets = workoutData.sets > 0 ? String(workoutData.sets) : ""
                            
                            isRecovery = workoutData.recovery
                            isOff = workoutData.off
                            isMeet = workoutData.meet
                            isTechnique = workoutData.technique
                            isWorkout = workoutData.workout
                            isTempo = workoutData.tempo
                            
                            isDayComplete = workoutData.dayComplete
                            
                            isTrack = workoutData.track
                            isIndoorTrack = workoutData.indoorTrack
                            isTurf = workoutData.turf
                            isDirt = workoutData.dirt
                            isGrassHills = workoutData.grasshills
                            isAsphalt = workoutData.asphalt
                            
                            isRain = workoutData.rain
                            isSnow = workoutData.snow
                            isWindy = workoutData.windy
                            isNormal = workoutData.normal
                            isHot = workoutData.hot
                            isCold = workoutData.cold
                            
                            isBlocks = workoutData.blocks
                            isResistanceBand = workoutData.resistanceBand
                            isWeights = workoutData.weights
                            isSled = workoutData.sled
                            isWickets = workoutData.wickets
                            isHurdles = workoutData.hurdles
                            isWeightedVest = workoutData.weightedVest
                            isPlyoBox = workoutData.plyoBox
                            isMedicineBall = workoutData.medicineBall
                            isStationaryBike = workoutData.stationaryBike
                            isTreadmill = workoutData.treadmill
                            
                            isInjury = workoutData.injury
                            isSoreness = workoutData.soreness
                            isFatigued = workoutData.fatigued
                            isPeakForm = workoutData.peakForm
                            
                            isLow = workoutData.low
                            isModerate = workoutData.moderate
                            isHigh = workoutData.high
                            isMaximum = workoutData.maximum
                            
                            isHighJump = workoutData.highJump
                            isPoleVault = workoutData.poleVault
                            isHammerThrow = workoutData.hammerThrow
                            isDiscus = workoutData.discus
                            isShotPut = workoutData.shotPut
                            isJavelin = workoutData.javelin
                            isLongJump = workoutData.longJump
                            isTripleJump = workoutData.tripleJump
                        }
                    } else {
                        // If no data is found use default values
                        workoutData = WorkoutData(date: Date(),
                                                  meters: [],
                                                  times: [],
                                                  sets: 0,
                                                  
                                                  recovery: false,
                                                  off: false,
                                                  meet: false,
                                                  technique: false,
                                                  workout: false,
                                                  tempo: false,
                                                  
                                                  dayComplete: false,
                                                  
                                                  track: false,
                                                  indoorTrack: false,
                                                  turf: false,
                                                  dirt: false,
                                                  grasshills: false,
                                                  asphalt: false,
                                                  
                                                  rain: false,
                                                  snow: false,
                                                  windy: false,
                                                  normal: false,
                                                  hot: false,
                                                  cold: false,
                                                  
                                                  blocks: false,
                                                  resistanceBand: false,
                                                  weights: false,
                                                  sled: false,
                                                  wickets: false,
                                                  hurdles: false,
                                                  weightedVest: false,
                                                  plyoBox: false,
                                                  medicineBall: false,
                                                  stationaryBike: false,
                                                  treadmill: false,
                                                  
                                                  injury: false,
                                                  soreness: false,
                                                  fatigued: false,
                                                  peakForm: false,
                                                  
                                                  low: false,
                                                  moderate: false,
                                                  high: false,
                                                  maximum: false,
                                                  
                                                  highJump: false,
                                                  poleVault: false,
                                                  hammerThrow: false,
                                                  discus: false,
                                                  shotPut: false,
                                                  javelin: false,
                                                  longJump: false,
                                                  tripleJump: false)
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
                        workoutData = WorkoutData(date: Date(),
                                                  meters: [],
                                                  times: [],
                                                  sets: 0,
                                                  
                                                  recovery: false,
                                                  off: false,
                                                  meet: false,
                                                  technique: false,
                                                  workout: false,
                                                  tempo: false,
                                                  
                                                  dayComplete: false,
                                                  
                                                  track: false,
                                                  indoorTrack: false,
                                                  turf: false,
                                                  dirt: false,
                                                  grasshills: false,
                                                  asphalt: false,
                                                  
                                                  rain: false,
                                                  snow: false,
                                                  windy: false,
                                                  normal: false,
                                                  hot: false,
                                                  cold: false,
                                                  
                                                  blocks: false,
                                                  resistanceBand: false,
                                                  weights: false,
                                                  sled: false,
                                                  wickets: false,
                                                  hurdles: false,
                                                  weightedVest: false,
                                                  plyoBox: false,
                                                  medicineBall: false,
                                                  stationaryBike: false,
                                                  treadmill: false,
                                                  
                                                  injury: false,
                                                  soreness: false,
                                                  fatigued: false,
                                                  peakForm: false,
                                                  
                                                  low: false,
                                                  moderate: false,
                                                  high: false,
                                                  maximum: false,
                                                  
                                                  highJump: false,
                                                  poleVault: false,
                                                  hammerThrow: false,
                                                  discus: false,
                                                  shotPut: false,
                                                  javelin: false,
                                                  longJump: false,
                                                  tripleJump: false)
                    } else {
                        isFieldModified = true
                        StreakData.updateStreakIfNeeded(fieldModified: isFieldModified)
                    }
                    workoutData?.meters = meters.compactMap { Int($0) }
                    workoutData?.times = times.compactMap { Int($0) }
                    workoutData?.sets = Int(numSets) ?? 0
                    
                    workoutData?.recovery = isRecovery
                    workoutData?.off = isOff
                    workoutData?.meet = isMeet
                    workoutData?.technique = isTechnique
                    workoutData?.workout = isWorkout
                    workoutData?.tempo = isTempo
                    
                    workoutData?.dayComplete = isDayComplete
                    
                    workoutData?.track = isTrack
                    workoutData?.indoorTrack = isIndoorTrack
                    workoutData?.turf = isTurf
                    workoutData?.dirt = isDirt
                    workoutData?.grasshills = isGrassHills
                    workoutData?.asphalt = isAsphalt
                    
                    workoutData?.rain = isRain
                    workoutData?.snow = isSnow
                    workoutData?.windy = isWindy
                    workoutData?.normal = isNormal
                    workoutData?.hot = isHot
                    workoutData?.cold = isCold
                    
                    workoutData?.blocks = isBlocks
                    workoutData?.resistanceBand = isResistanceBand
                    workoutData?.weights = isWeights
                    workoutData?.sled = isSled
                    workoutData?.wickets = isWickets
                    workoutData?.hurdles = isHurdles
                    workoutData?.weightedVest = isWeightedVest
                    workoutData?.plyoBox = isPlyoBox
                    workoutData?.medicineBall = isMedicineBall
                    workoutData?.stationaryBike = isStationaryBike
                    workoutData?.treadmill = isTreadmill
                    
                    workoutData?.injury = isInjury
                    workoutData?.soreness = isSoreness
                    workoutData?.fatigued = isFatigued
                    workoutData?.peakForm = isPeakForm
                    
                    workoutData?.low = isLow
                    workoutData?.moderate = isModerate
                    workoutData?.high = isHigh
                    workoutData?.maximum = isMaximum
                    
                    workoutData?.highJump = isHighJump
                    workoutData?.poleVault = isPoleVault
                    workoutData?.hammerThrow = isHammerThrow
                    workoutData?.discus = isDiscus
                    workoutData?.shotPut = isShotPut
                    workoutData?.javelin = isJavelin
                    workoutData?.longJump = isLongJump
                    workoutData?.tripleJump = isTripleJump
                    
                    workoutData?.saveData()
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                    // Save the state of complete day mode to UserDefaults
                    UserDefaults.standard.set(isDayComplete, forKey: "isDayComplete")
                    
                    onDisappearAction?(isFieldModified)
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
    
    // Function to validate the input for time
    func validateTimeInput(_ input: String) -> Bool {
        return (input.isEmpty || Int(input) != nil) && input.count <= 5
    }
    
    // Function to validate the input for meters
    func validateMetersInput(_ input: String) -> Bool {
        return (input.isEmpty || Int(input) != nil) && input.count <= 5
    }
    
    // Function to validate the input for the number of reps
    func validateNumberOfRepsInput(_ input: String) -> Bool {
        return (input.isEmpty || Int(input) != nil) && input.count <= 5
    }
    
    // Function to reset isDayComplete if it's a new day
    func resetDayCompletionIfNeeded() {
        // Retrieve last complete date from UserDefaults
        if let lastCompleteDate = UserDefaults.standard.object(forKey: "lastCompleteDate") as? Date {
            // Check if last complete date is not today
            if !Calendar.current.isDateInToday(lastCompleteDate) {
                isDayComplete = false
                UserDefaults.standard.set(false, forKey: "isDayComplete")
                
                // Optionally reset selectedExperience
                selectedExperience = nil
                UserDefaults.standard.set(nil, forKey: "SelectedExperience")
                
                // Update last complete date to today
                UserDefaults.standard.set(Date(), forKey: "lastCompleteDate")
            }
        } else {
            // No last complete date found, likely first launch, set it to today
            UserDefaults.standard.set(Date(), forKey: "lastCompleteDate")
        }
    }
    
    // Makes a notification that will go off at the correct date
    func scheduleNotification(for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Complete recovery!"
        content.body = "Look at recovery suggestions in the Workout tab to view suggestions."
        content.sound = UNNotificationSound.default
        
        var triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: date)
        triggerDate.hour = 13
        triggerDate.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: date.formatted(), content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for \(date.formatted())")
            }
        }
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
