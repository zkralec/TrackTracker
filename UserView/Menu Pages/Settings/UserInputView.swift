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
    @State var isSideMenuOpen = false
    @State private var gender = Gender.male
    @State private var userData: UserData?
    @State private var currPage: Int = -1
    @ObservedObject var userDataManager = UserDataManager.shared
    @Environment(\.colorScheme) var colorScheme // Access the current color scheme

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
                ZStack {
                    VStack {
                        // Menu bar icon
                        MenuButton(isSideMenuOpen: $isSideMenuOpen)
                        
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
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                        .onTapGesture {
                                            isFocused = true
                                        }
                                    
                                    TextField("Last Name", text: $lName)
                                        .textFieldStyle(DefaultTextFieldStyle())
                                        .padding(10)
                                        .roundedBackground()
                                        .padding(10)
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                        .onTapGesture {
                                            isFocused = true
                                        }
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
                                    .padding(5)
                                }
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
                                    
                                    TextField("Enter weight (lbs)", value: $weight, formatter: NumberFormatter())
                                        .keyboardType(.numberPad)
                                        .padding()
                                        .textFieldStyle(DefaultTextFieldStyle())
                                        .roundedBackground()
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                        .onTapGesture {
                                            isFocused = true
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
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                                .padding()
                            }
                            .listSectionSpacing(15)
                        }
                        .modifier(ToolbarModifier(isFocused: $isFocused))
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
                        let userData = UserData(gender: UserData.Gender(rawValue: gender.rawValue) ?? .male, fName: fName, lName: lName, heightFeet: heightFeet, heightInches: heightInches, weight: weight, age: age)
                        userData.saveUserData()
                        
                        if currPage != -1 {
                            GlobalVariables.userInput = true
                        }
                    }
                    // Show side menu if needed
                    SideBar(currPage: $currPage, isSideMenuOpen: $isSideMenuOpen)
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
        } else if currPage == 8 {
            TrainingLogView()
        }
    }
}

#Preview {
    UserInputView()
}
