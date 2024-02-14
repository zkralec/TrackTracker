//
//  UserInputView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/16/24.
//

import SwiftUI

// Manages global variable
struct GlobalVariables {
    @AppStorage("hasCompletedInput") static var hasCompletedInput: Bool = false
}

// Page to gather user data
struct UserInputView: View {
    @State private var heightFeet: Int = 0
    @State private var heightInches: Int = 0
    @State private var weight: Double = 0.0
    @State private var age: Int = 0
    @State private var isEditing = false
    @State private var selectedGender = Gender.male
    @State private var userData: UserData?
    @State private var currentPage: Int = -1
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
        if currentPage == -1 {
            if !GlobalVariables.hasCompletedInput {
                VStack {
                    // Instructions
                    Text("Please enter your height, weight, age, and gender")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.blue)
                                .frame(width: 380, height: 80)
                                .padding(.horizontal, 20)
                        )
                        .padding(.bottom)
                    
                    List {
                        VStack {
                            // Height section
                            Text("Height")
                                .font(.headline)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .center)
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
                        .cornerRadius(15)
                        
                        // Weight section
                        VStack {
                            Text("Weight (lbs)")
                                .font(.headline)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(10)
                            
                            TextField("Enter weight (lbs)", value: $weight, formatter: NumberFormatter(), onEditingChanged: { editing in
                                self.isEditing = editing
                            })
                            .keyboardType(.numberPad)
                            .padding()
                            .textFieldStyle(DefaultTextFieldStyle())
                            .roundedBackground()
                            
                            // Done button for weight input
                            if isEditing {
                                Button("Done") {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                                .buttonStyle(CustomButtonStyle())
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                            }
                        }
                        
                        // Age section
                        VStack {
                            Text("Age")
                                .font(.headline)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(10)
                            
                            Picker("Age", selection: $age) {
                                ForEach(18..<100) { age in
                                    Text("\(age)")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .padding(.horizontal, 110)
                        }
                        
                        // Gender section
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text("Gender")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(10)
                                
                                Picker("", selection: $selectedGender) {
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
                    .padding(.horizontal, -15)
                    .listStyle(PlainListStyle())
                    .background(Color.gray.opacity(0.05))
                        
                    // Save data button
                    if !isEditing {
                        Button("Save") {
                            let userData = UserData(gender: UserData.Gender(rawValue: selectedGender.rawValue) ?? .male, heightFeet: heightFeet, heightInches: heightInches, weight: weight, age: age)
                            currentPage = 4
                            userData.saveUserData()
                            userDataManager.userData = userData
                            userDataManager.calculateMaintenanceCalories()
                            GlobalVariables.hasCompletedInput = true
                        }
                        .buttonStyle(CustomButtonStyle())
                        .frame(width: 120, height: 40)
                        .disabled(heightFeet == 0 || weight == 0.0)
                        .padding()
                    }
                }
                .onAppear {
                    // Load user data
                    if let userData = UserData.loadUserData() {
                        self.userDataManager.userData = userData
                        self.heightFeet = userData.heightFeet
                        self.heightInches = userData.heightInches
                        self.weight = userData.weight
                        self.age = userData.age
                        self.selectedGender = Gender(rawValue: userData.gender.rawValue) ?? .male
                    }
                }
                .onDisappear {
                    // Save user data
                    let userData = UserData(gender: UserData.Gender(rawValue: selectedGender.rawValue) ?? .male, heightFeet: heightFeet, heightInches: heightInches, weight: weight, age: age)
                    userData.saveUserData()
                }
                .onChange(of: userData) { newValue, _ in
                    // Save user data on change
                    guard let newValue = newValue else { return }
                    newValue.saveUserData()
                }
                .padding()
                
            } else {
                HomeView()
            }
        } else if currentPage == 4 {
            SettingsView()
        }
    }
}

#Preview {
    UserInputView()
}
