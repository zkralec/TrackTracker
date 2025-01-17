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
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    // Have the meters or times field appear depending on saved values
    init() {
        // Safely unwrap optional data
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
                                withAnimation {
                                    showRecoverySuggestions = true
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
                                        showRecoverySuggestions = true
                                        // Schedules recovery notification
                                        scheduleNotification(for: currDate)
                                        
                                        workoutData?.meters = meters.compactMap { Int($0) }
                                        workoutData?.times = times.compactMap { Int($0) }
                                        workoutData?.sets = Int(numSets) ?? 0
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
                        RecoveryPrompt(isPresented: $showRecoverySuggestions, selectedExperience: $selectedExperience)
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
                                                    if !isDayComplete {
                                                        withAnimation {
                                                            isFocused = true
                                                            focusedField = index
                                                        }
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
                                                    if !isDayComplete {
                                                        withAnimation {
                                                            isFocused = true
                                                            focusedField = index
                                                        }
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
                        }
                    } else {
                        // If no data is found use default values
                        workoutData = WorkoutData(date: Date(),
                                                  meters: [],
                                                  times: [],
                                                  sets: 0,
                                                  dayComplete: false)
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
                                                  dayComplete: false)
                    } else {
                        isFieldModified = true
                        StreakData.updateStreakIfNeeded(fieldModified: isFieldModified)
                    }
                    workoutData?.meters = meters.compactMap { Int($0) }
                    workoutData?.times = times.compactMap { Int($0) }
                    workoutData?.sets = Int(numSets) ?? 0
                    workoutData?.dayComplete = isDayComplete
                    
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
