//
//  HomePageView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/16/24.
//

import SwiftUI

// Other main page for the user, mainly lots of UI and fields
struct WorkoutView: View {
    @State private var currentDate = Date()
    @State private var currentPage: Int = 0
    @State private var meters: [String] = [""]
    @State private var numberOfReps = ""
    @State private var isBlocksUsed = false
    @State private var isRecoveryDay = false
    @State private var isGrass = false
    @State private var isHills = false
    @State private var isFieldModified = false
    @State private var workoutData: WorkoutData?
    
    @AppStorage("isDayComplete") private var isDayComplete = false
    
    var onDisappearAction: ((Bool) -> Void)?
    
    var body: some View {
        if currentPage == 0 {
            VStack {
                VStack {
                    // Display title
                    TitleBackground(title: "Workouts")
                    
                    HStack {
                        // Display current date
                        Text(currentDate, formatter: dateFormatter)
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.leading, 150)
                        
                        Spacer()
                        
                        // Complete Day button
                        Button(action: {
                            isDayComplete.toggle()
                            if isDayComplete {
                                if workoutData == nil {
                                    workoutData = WorkoutData(date: Date(), meters: [], numberOfReps: 0, blocks: false, recovery: false, grass: false, hills: false)
                                }
                                workoutData?.meters = meters.compactMap { Int($0) }
                                workoutData?.numberOfReps = Int(numberOfReps) ?? 0
                                workoutData?.blocks = isBlocksUsed
                                workoutData?.recovery = isRecoveryDay
                                workoutData?.saveData()
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                        VStack {
                            Text("Reps Ran")
                                .font(.headline)
                                .fontWeight(.medium)
                                .padding(10)
                            
                            // Halves meters fields in half for space saving after 4 fields
                            if meters.count <= 4 {
                                VStack() {
                                    ForEach(meters.indices, id: \.self) { index in
                                        TextField("Meters", text: Binding(
                                            get: { meters[index] },
                                            set: { newValue in
                                                meters[index] = newValue
                                            }
                                        ))
                                        .keyboardType(.numberPad)
                                        .padding(10)
                                        .disabled(isDayComplete)
                                        .roundedBackground()
                                    }
                                }
                            } else {
                                HStack(alignment: .top) {
                                    VStack {
                                        ForEach(0..<4, id: \.self) { index in
                                            TextField("Meters", text: Binding(
                                                get: { meters[index] },
                                                set: { newValue in
                                                    meters[index] = newValue
                                                }
                                            ))
                                            .keyboardType(.numberPad)
                                            .padding(10)
                                            .disabled(isDayComplete)
                                            .roundedBackground()
                                        }
                                    }
                                    
                                    // For values in meters
                                    VStack {
                                        ForEach(4..<meters.count, id: \.self) { index in
                                            TextField("Meters", text: Binding(
                                                get: { meters[index] },
                                                set: { newValue in
                                                    meters[index] = newValue
                                                }
                                            ))
                                            .keyboardType(.numberPad)
                                            .padding(10)
                                            .disabled(isDayComplete)
                                            .roundedBackground()
                                        }
                                    }
                                }
                            }
                            
                            // Buttons to add or remove reps
                            if !isDayComplete {
                                HStack {
                                    VStack {
                                        Button(action: {
                                            if meters.count < 8 {
                                                meters.append("")
                                            }
                                        }) {
                                            Image(systemName: "plus")
                                                .foregroundStyle(.white)
                                                .frame(width: 30, height: 10)
                                        }
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
                                        .buttonStyle(CustomButtonStyle())
                                        
                                        Text("Remove")
                                            .font(.caption)
                                            .foregroundStyle(.blue)
                                            .padding(4)
                                    }
                                }
                                .padding(10)
                                .padding(.top, 5)
                            }
                            
                            // Sets field
                            Text("Sets")
                                .font(.headline)
                                .fontWeight(.medium)
                                .padding(10)
                            
                            TextField("Number of Sets", text: Binding(
                                get: { numberOfReps },
                                set: { newValue in
                                    if validateNumberOfRepsInput(newValue) {
                                        numberOfReps = newValue
                                    }
                                }
                            ))
                            .keyboardType(.numberPad)
                            .padding(10)
                            .disabled(isDayComplete)
                            .roundedBackground()
                            
                            VStack {
                                HStack {
                                    //Toggle for Blocks
                                    Toggle("Blocks", isOn: $isBlocksUsed)
                                        .font(.subheadline)
                                        .disabled(isDayComplete)
                                        .roundedBackground()
                                    
                                    // Toggle for Recovery day
                                    Toggle("Recovery", isOn: $isRecoveryDay)
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
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.gray.opacity(0.05))
                }
                
                // Navigation buttons
                HStack {
                    VStack {
                        // Exercise button
                        Button(action: {
                            currentPage = 1
                        }) {
                            Image(systemName: "dumbbell.fill")
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .frame(width: 120, height: 40)
                        
                        Text("Exercises")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                    
                    VStack {
                        // Home button
                        Button(action: {
                            currentPage = 3
                        }) {
                            Image(systemName: "house.fill")
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .frame(width: 120, height: 40)
                        
                        Text("Home")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                    
                    VStack {
                        // Meals button
                        Button(action: {
                            currentPage = 2
                        }) {
                            Image(systemName: "fork.knife")
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .frame(width: 120, height: 40)
                        
                        Text("Meals")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                }
                .padding()
            }
            .onAppear {
                // Update the empty storage before loading data
                WorkoutData.updateDataAtStartOfDay(currentDate: currentDate)
                
                // Load workout data
                if workoutData == nil {
                    workoutData = WorkoutData(date: Date(), meters: [], numberOfReps: 0, blocks: isBlocksUsed, recovery: isRecoveryDay, grass: isGrass, hills: isHills)
                }
                if let loadedData = workoutData?.loadData() {
                    workoutData = loadedData
                    
                    if let workoutData = workoutData {
                        meters = workoutData.meters.isEmpty ? [""] : workoutData.meters.map { String($0) }
                        numberOfReps = workoutData.numberOfReps > 0 ? String(workoutData.numberOfReps) : ""
                        isBlocksUsed = workoutData.blocks
                        isRecoveryDay = workoutData.recovery
                        isGrass = workoutData.grass
                        isHills = workoutData.hills
                    }
                }
                
                // Retrieve the state of complete day mode from UserDefaults
                isDayComplete = UserDefaults.standard.bool(forKey: "isDayComplete")
            }
            .onDisappear {
                if workoutData == nil {
                    workoutData = WorkoutData(date: Date(), meters: [], numberOfReps: 0, blocks: false, recovery: false, grass: false, hills: false)
                } else {
                    isFieldModified = true
                    StreakData.updateStreakIfNeeded(fieldModified: isFieldModified)

                }
                workoutData?.meters = meters.compactMap { Int($0) }
                workoutData?.numberOfReps = Int(numberOfReps) ?? 0
                workoutData?.blocks = isBlocksUsed
                workoutData?.recovery = isRecoveryDay
                workoutData?.grass = isGrass
                workoutData?.hills = isHills
                workoutData?.saveData()
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
                // Save the state of complete day mode to UserDefaults
                UserDefaults.standard.set(isDayComplete, forKey: "isDayComplete")
                
                onDisappearAction?(isFieldModified)
            }
        } else if currentPage == 1 {
            ExerciseView()
        } else if currentPage == 2 {
            MealsView()
        } else if currentPage == 3 {
            HomeView()
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
