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
    @State private var fName = ""
    @State private var lName = ""
    @State private var heightFeet: Int = 0
    @State private var heightInches: Int = 0
    @State private var weight: Double = 0.0
    @State private var age: Int = 0
    @State private var isFocused = false
    @State private var gender = Gender.male
    @State private var userData: UserData?
    @State private var currPage: Int = -1
    @ObservedObject var userDataManager = UserDataManager.shared
    
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
            if !GlobalVariables.userInput {
                VStack {
                    // Display title
                    TitleBackground(title: "User Information")
                    
                    List {
                        // Name section
                        Section {
                            VStack {
                                Text("Name")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .padding(10)
                                
                                TextField("First Name", text: $fName)
                                    .textFieldStyle(DefaultTextFieldStyle())
                                    .padding(10)
                                    .roundedBackground()
                                    .padding(10)
                                
                                TextField("Last Name", text: $lName)
                                    .textFieldStyle(DefaultTextFieldStyle())
                                    .padding(10)
                                    .roundedBackground()
                                    .padding(10)
                            }
                        }
                        
                        // Height section
                        Section {
                            VStack {
                                Text("Height")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .padding(10)
                                
                                HStack {
                                    Picker("Feet", selection: $heightFeet) {
                                        ForEach(3..<9) { feet in
                                            Text("\(feet) ft").tag(feet)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    
                                    Picker("Inches", selection: $heightInches) {
                                        ForEach(0..<12) { inches in
                                            Text("\(inches) in").tag(inches)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                }
                                .padding(5)
                            }
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        .listSectionSpacing(15)
                        
                        // Weight section
                        Section {
                            VStack {
                                Text("Weight (lbs)")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .padding(10)
                                
                                TextField("Enter weight (lbs)", value: $weight, formatter: NumberFormatter(), onEditingChanged: { editing in
                                    self.isFocused = editing
                                })
                                .keyboardType(.numberPad)
                                .padding()
                                .textFieldStyle(DefaultTextFieldStyle())
                                .roundedBackground()
                                
                                // Done button for weight input
                                if isFocused {
                                    Button("Done") {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                    .buttonStyle(CustomButtonStyle())
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                                }
                            }
                        }
                        .listSectionSpacing(15)
                        
                        // Age section
                        Section {
                            VStack {
                                Text("Age")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .padding(10)
                                
                                Picker("Age", selection: $age) {
                                    ForEach(18..<100) { age in
                                        Text("\(age)")
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .padding(.horizontal, 110)
                            }
                        }
                        .listSectionSpacing(15)
                        
                        // Gender section
                        Section {
                            HStack {
                                Spacer()
                                
                                VStack {
                                    Text("Gender")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .padding(10)
                                    
                                    Picker("", selection: $gender) {
                                        ForEach(Gender.allCases) { gender in
                                            Text(gender.rawValue).tag(gender)
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(DefaultPickerStyle())
                                    .padding(.trailing, 10)
                                    .roundedBackground()
                                    .tint(.black)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            .padding()
                        }
                        .listSectionSpacing(15)
                    }
                    .background(Color.gray.opacity(0.05))
                }
                .onAppear {
                    // Load user data
                    if let userData = UserData.loadUserData() {
                        self.userDataManager.userData = userData
                        self.fName = userData.fName
                        self.lName = userData.lName
                        self.heightFeet = userData.heightFeet
                        self.heightInches = userData.heightInches
                        self.weight = userData.weight
                        self.age = userData.age
                        self.gender = Gender(rawValue: userData.gender.rawValue) ?? .male
                    }
                }
                .onDisappear {
                    // Save user data
                    let userData = UserData(gender: UserData.Gender(rawValue: gender.rawValue) ?? .male, fName: fName, lName: lName,heightFeet: heightFeet, heightInches: heightInches, weight: weight, age: age)
                    userData.saveUserData()
                    
                    GlobalVariables.userInput = true
                }
                
                // Navigation bar buttons
                if !isFocused {
                    VStack {
                        NavigationBar(currPage: $currPage)
                            .disabled(fName == "" || lName == "" || heightFeet <= 3 || weight <= 70)
                    }
                }
            } else {
                HomeView()
            }
        } else if currPage == 0 {
            WorkoutView()
        } else if currPage == 1 {
            ExerciseView()
        } else if currPage == 2 {
            MealsView()
        } else if currPage == 3 {
            HomeView()
        }
    }
}

#Preview {
    UserInputView()
}
