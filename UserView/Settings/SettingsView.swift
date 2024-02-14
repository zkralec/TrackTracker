//
//  SettingsView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import SwiftUI

// Holds all the settings the user can modify
struct SettingsView: View {
    @State private var currentPage: Int = 4
    @State private var selectedEvents: [EventData] = {
    if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
        return savedEvents.compactMap { EventData(rawValue: $0) }
    } else {
        return []
    }
    }()
    @State private var personalRecords = [EventData: String]()
    @State private var meets: [Date] = []
    @StateObject var userDataManager = UserDataManager()
    
    var body: some View {
        if currentPage == 4 {
            VStack {
                // Display title
                TitleBackground(title: "Settings")
                
                HStack {
                    // Back button
                    Button(action: {
                        currentPage = 3
                    }) {
                        Image(systemName: "arrowshape.backward.fill")
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 5)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .padding(.vertical)
                    .padding(.leading, 22)
                    
                    Text("Select a setting to modify")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
            }
            
            List {
                VStack {
                    // Display user information
                    if let userData = userDataManager.userData {
                        Text("User Information")
                            .font(.headline)
                            .fontWeight(.medium)
                            .padding()
                        Text("Height: \(userData.heightFeet)' \(userData.heightInches)\"")
                            .font(.subheadline)
                            .padding(5)
                            .roundedBackground()
                        Text("Weight: \(formatWeight(userData.weight))")
                            .font(.subheadline)
                            .padding(5)
                            .roundedBackground()
                        Text("Age: \(userData.age + 18)")
                            .font(.subheadline)
                            .padding(5)
                            .roundedBackground()
                        Text("Gender: \(userData.gender.rawValue)")
                            .font(.subheadline)
                            .padding(5)
                            .roundedBackground()
                    }
                    
                    // Settings for user info
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            GlobalVariables.hasCompletedInput = false
                            currentPage = -1
                        }) {
                            Text("Modify")
                        }
                        .buttonStyle(CustomButtonStyle())
                        .padding()
                        
                        Spacer()
                    }
                }
                
                // Shows users their events and allows for PR input
                VStack {
                    if selectedEvents.isEmpty {
                        Text("No selected events")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        Text("Selected Events")
                            .font(.headline)
                            .fontWeight(.medium)
                            .padding()
                        ForEach(selectedEvents, id: \.self) { event in
                            HStack {
                                Text(event.rawValue)
                                    .padding(5)
                                    .roundedBackground()
                                Spacer()
                                TextField("Enter PR", text: Binding(
                                    get: {
                                        personalRecords[event] ?? ""
                                    },
                                    set: { newValue in
                                        personalRecords[event] = newValue
                                        savePR(for: event, prValue: newValue)
                                    }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }
                    
                    // Settings for events and PRs
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            currentPage = 5
                        }) {
                            Text("Select Events")
                        }
                        .buttonStyle(CustomButtonStyle())
                        .padding()
                        
                        Spacer()
                    }
                }
                
                // Display meet dates
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Text("Meet Days")
                                .font(.headline)
                                .fontWeight(.medium)
                                .padding()
                            
                            if meets.isEmpty {
                                Text("No meet days selected")
                                    .foregroundColor(.secondary)
                                    .padding()
                                    .roundedBackground()
                            } else {
                                ForEach(meets, id: \.self) { date in
                                    Text(date.formatted())
                                        .padding(5)
                                        .roundedBackground()
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    // Settings for meet dates
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            currentPage = 6
                        }) {
                            Text("Select Meets")
                        }
                        .buttonStyle(CustomButtonStyle())
                        .padding()
                        
                        Spacer()
                    }
                }
                .onAppear {
                    loadPR()
                    loadMeets()
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.gray.opacity(0.05))
            .onAppear {
                loadMeets()
            }
        } else if currentPage == -1 {
            UserInputView()
        } else if currentPage == 3 {
            HomeView()
        } else if currentPage == 5 {
            EventView(selectedEvents: $selectedEvents)
        } else if currentPage == 6 {
            MeetView()
        }
    }
    
    // Format weight to display with correct units
    private func formatWeight(_ weight: Double) -> String {
        let weightFormatter = NumberFormatter()
        weightFormatter.maximumFractionDigits = weight.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 1
        return "\(weightFormatter.string(from: NSNumber(value: weight)) ?? "") lbs"
    }

    // Load in the current meet dates
    func loadMeets() {
        if let data = UserDefaults.standard.data(forKey: "meetDates") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Date].self, from: data) {
                meets = decoded
            }
        }
    }
    
    // Save the user's event PRs
    func savePR(for event: EventData, prValue: String) {
        print("Saving PRs")
        print("PR: \(prValue)")
        print("Event: \(event.rawValue)")
        for (event, prValue) in personalRecords {
            UserDefaults.standard.set(prValue, forKey: event.rawValue)
        }
    }
    
    // Load the user's event PRs
    func loadPR() {
        for event in selectedEvents {
            if let prValue = UserDefaults.standard.string(forKey: event.rawValue) {
                personalRecords[event] = prValue
            }
        }
    }
}

#Preview {
    SettingsView()
}
