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
    @State private var currPage: Int = 0
    @State private var isSideMenuOpen = false
    @State private var meters: [String] = [""]
    @State private var numSets = ""
    @State private var isFieldModified = false
    @State private var isFocused = false
    @State private var showExperiencePrompt = false
    @State private var selectedExperience: String? = UserDefaults.standard.string(forKey: "SelectedExperience")
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
    
    @FocusState private var focusedField: Int?
    @AppStorage("isDayComplete") private var isDayComplete = false
    
    var onDisappearAction: ((Bool) -> Void)?
    private var previousDaysData: [WorkoutData] = []
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
                            if !isMeet && !isOff && !isRecovery && !isInjury && isDayComplete {
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
                                    }
                                } else {
                                    selectedExperience = nil
                                }
                                if settings.isHapticsEnabled {
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
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
                                VStack {
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
                                        .onTapGesture {
                                            withAnimation {
                                                self.isFocused = true
                                                self.focusedField = index
                                            }
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
                                                    if meters.count < 6 {
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
                        .padding(.bottom, 15)
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
                                .focused($focusedField, equals: 200)
                                .onTapGesture {
                                    withAnimation {
                                        self.isFocused = true
                                        self.focusedField = 200
                                    }
                                }
                                .roundedBackground()
                            }
                        }
                        .padding(.bottom, 15)
                        .listSectionSpacing(15)
                        
                        // Section for the training or day type
                        Section {
                            DisclosureGroup("Day Type") {
                                VStack(spacing: 15) {
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
                                            .disabled(isDayComplete || (!binding.wrappedValue && anyDayToggleOn))
                                            .padding(.horizontal, 10)
                                    }
                                }
                            }
                            .fontWeight(.medium)
                        }
                        .listSectionSpacing(15)
                        
                        // Surface Section
                        Section {
                            DisclosureGroup("Surface") {
                                VStack(spacing: 15) {
                                    ForEach([
                                        ("Outdoor Track", $isTrack),
                                        ("Indoor Track", $isIndoorTrack),
                                        ("Turf", $isTurf),
                                        ("Dirt", $isDirt),
                                        ("Grass/Hills", $isGrassHills),
                                        ("Asphalt", $isAsphalt)
                                    ], id: \.0) { label, binding in
                                        Toggle(label, isOn: binding)
                                            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                            .font(.subheadline)
                                            .disabled(isDayComplete || (!binding.wrappedValue && anySurfaceToggleOn))
                                            .padding(.horizontal, 10)
                                    }
                                }
                            }
                            .fontWeight(.medium)
                        }
                        .listSectionSpacing(15)
                        
                        // Weather Section
                        Section {
                            DisclosureGroup("Weather") {
                                VStack(spacing: 15) {
                                    ForEach([
                                        ("Rain", $isRain),
                                        ("Snow", $isSnow),
                                        ("Windy", $isWindy),
                                        ("Normal", $isNormal),
                                        ("Hot", $isHot),
                                        ("Cold", $isCold)
                                    ], id: \.0) { label, binding in
                                        Toggle(label, isOn: binding)
                                            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                            .font(.subheadline)
                                            .disabled(isDayComplete)
                                            .padding(.horizontal, 10)
                                    }
                                }
                            }
                            .fontWeight(.medium)
                        }
                        .listSectionSpacing(15)
                        
                        // Equipment Section
                        Section {
                            DisclosureGroup("Equipment") {
                                VStack(spacing: 15) {
                                    ForEach([
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
                                    ], id: \.0) { label, binding in
                                        Toggle(label, isOn: binding)
                                            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                            .font(.subheadline)
                                            .disabled(isDayComplete)
                                            .padding(.horizontal, 10)
                                    }
                                }
                            }
                            .fontWeight(.medium)
                        }
                        .listSectionSpacing(15)
                        
                        // Condition Section
                        Section {
                            DisclosureGroup("Condition") {
                                VStack(spacing: 15) {
                                    ForEach([
                                        ("Injury", $isInjury),
                                        ("Soreness", $isSoreness),
                                        ("Fatigued", $isFatigued),
                                        ("Peak Form", $isPeakForm)
                                    ], id: \.0) { label, binding in
                                        Toggle(label, isOn: binding)
                                            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                            .font(.subheadline)
                                            .disabled(isDayComplete || (!binding.wrappedValue && anyConditionToggleOn))
                                            .padding(.horizontal, 10)
                                    }
                                }
                            }
                            .fontWeight(.medium)
                        }
                        .listSectionSpacing(15)
                        
                        // Intensity Section
                        Section {
                            DisclosureGroup("Intensity") {
                                VStack(spacing: 15) {
                                    ForEach([
                                        ("Low", $isLow),
                                        ("Moderate", $isModerate),
                                        ("High", $isHigh),
                                        ("Maximum", $isMaximum)
                                    ], id: \.0) { label, binding in
                                        Toggle(label, isOn: binding)
                                            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                            .font(.subheadline)
                                            .disabled(isDayComplete || (!binding.wrappedValue && anyIntensityToggleOn))
                                            .padding(.horizontal, 10)
                                    }
                                }
                            }
                            .fontWeight(.medium)
                        }
                        .listSectionSpacing(15)
                        
                        // Field Events Section
                        Section {
                            DisclosureGroup("Field Events") {
                                VStack(spacing: 15) {
                                    ForEach([
                                        ("High Jump", $isHighJump),
                                        ("Pole Vault", $isPoleVault),
                                        ("Hammer Throw", $isHammerThrow),
                                        ("Discus", $isDiscus),
                                        ("Shot Put", $isShotPut),
                                        ("Javelin", $isJavelin),
                                        ("Long Jump", $isLongJump),
                                        ("Triple Jump", $isTripleJump)
                                    ], id: \.0) { label, binding in
                                        Toggle(label, isOn: binding)
                                            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                            .font(.subheadline)
                                            .disabled(isDayComplete)
                                            .padding(.horizontal, 10)
                                    }
                                }
                            }
                            .fontWeight(.medium)
                        }
                        .listSectionSpacing(15)
                    }
                    .modifier(ToolbarModifier(isFocused: $isFocused))
                    
                    // Navigation bar buttons
                    if !isFocused {
                        VStack {
                            NavigationBar(currPage: $currPage)
                        }
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
                SideBar(currPage: $currPage, isSideMenuOpen: $isSideMenuOpen)
            }
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
        } else if currPage == 7 {
            ProfileView()
        } else if currPage == 8 {
            TrainingLogView()
        } else if currPage == 9 {
            InjuryView()
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
    
    // Function to reset isDayComplete if it's a new day
    private func resetDayCompletionIfNeeded() {
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
