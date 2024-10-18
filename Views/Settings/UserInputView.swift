//
//  UserInputView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/16/24.
//

import SwiftUI

// Manages global variable
struct GlobalVariables {
    @AppStorage("hasCompletedInput") static var userInput: Bool = false
}

// Page to gather user data
struct UserInputView: View {
    @State private var heightFeet: Int = 0
    @State private var heightInches: Int = 0
    @State private var weight: Double = 0.0
    @State private var age: Int = 0
    @State private var isFocused = false
    @State var isSideMenuOpen = false
    @State private var gender = Gender.male
    @State private var userData: UserData?
    @State private var currPage: Int = -1
    
    @FocusState private var focusedField: Int?
    @ObservedObject var userDataManager = UserDataManager.shared
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()

    // Gender enum
    enum Gender: String, CaseIterable, Identifiable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        // If the user has not completed input send to this view
        if currPage == -1 {
                ZStack {
                    VStack {
                        ZStack {
                            // Display title
                            TitleBackground(title: "User Information")
                            
                            HStack {
                                // Menu bar icon
                                MenuButton(isSideMenuOpen: $isSideMenuOpen)
                                Spacer()
                            }
                        }
                        
                        List {
                            // Height section
                            Section("Height") {
                                HStack {
                                    Picker("Feet", selection: $heightFeet) {
                                        ForEach(3..<9) { feet in
                                            Text("\(feet) ft").tag(feet)
                                                .foregroundStyle(Color.primary)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    
                                    Picker("Inches", selection: $heightInches) {
                                        ForEach(0..<12) { inches in
                                            Text("\(inches) in").tag(inches)
                                                .foregroundStyle(Color.primary)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                }
                            }
                            .listSectionSpacing(15)
                            
                            // Weight section
                            Section("Weight") {
                                TextField("Enter weight (lbs)", value: $weight, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .padding(10)
                                    .focused($focusedField, equals: 201)
                                    .contentShape(Rectangle())
                                    .highPriorityGesture(
                                        TapGesture().onEnded {
                                            withAnimation {
                                                isFocused = true
                                                focusedField = 201
                                            }
                                        }
                                    )
                                    .roundedBackground()
                                    .padding(10)
                            }
                            .listSectionSpacing(15)
                            
                            // Age section
                            Section("Age") {
                                Picker("Age", selection: $age) {
                                    ForEach(18..<100) { age in
                                        Text("\(age)")
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                            }
                            .listSectionSpacing(15)
                            
                            // Gender section
                            Section("Gender") {
                                Picker("", selection: $gender) {
                                    ForEach(Gender.allCases) { gender in
                                        Text(gender.rawValue).tag(gender)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(DefaultPickerStyle())
                                .tint(Color.primary)
                                .padding(.vertical, 6)
                            }
                            .listSectionSpacing(15)
                        }
                        .modifier(ToolbarModifier(isFocused: $isFocused))
                    }
                    .onAppear {
                        // Load user data
                        if let userData = UserData.loadUserData() {
                            self.userDataManager.userData = userData
                            self.heightFeet = userData.heightFeet
                            self.heightInches = userData.heightInches
                            self.weight = userData.weight
                            self.age = userData.age
                            self.gender = Gender(rawValue: userData.gender.rawValue) ?? .male
                        }
                    }
                    .onDisappear {
                        // Save user data
                        let userData = UserData(gender: UserData.Gender(rawValue: gender.rawValue) ?? .male, heightFeet: heightFeet, heightInches: heightInches, weight: weight, age: age)
                        userData.saveUserData()
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
        } else if currPage == 8 {
            TrainingLogView()
        } else if currPage == 9 {
            InjuryView()
        }
    }
}
