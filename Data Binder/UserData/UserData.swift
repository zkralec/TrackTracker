//
//  UserData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/16/24.
//

import Foundation

// Holds user data
struct UserData: Codable, Equatable {
    // Enum for gender
    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }
    
    // User gender, height, weight, and age
    var gender = Gender.male
    var fName = "First Name"
    var lName = "Last Name"
    var email = "name@example.com"
    var heightFeet = 6
    var heightInches = 0
    var weight = 175.0
    var age = 21
    
    // Clear user data ONLY USE WHEN ADDING NEW VARIABLES
    func clearUserData() {
        UserDefaults.standard.removeObject(forKey: "userData")
        print("Cleared all user data.")
    }
    
    // Save user data to  storage
    func saveUserData() {
        do {
            let encodedData = try JSONEncoder().encode(self)
            UserDefaults.standard.set(encodedData, forKey: "userData")
            print("User data saved.")
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }
    
    // Load user data
    static func loadUserData() -> UserData? {
        guard let encodedData = UserDefaults.standard.data(forKey: "userData") else {
            return nil
        }
        
        do {
            let userData = try JSONDecoder().decode(UserData.self, from: encodedData)
            print("User data loaded.")
            return userData
        } catch {
            print("Error loading user data: \(error.localizedDescription)")
            return nil
        }
    }
}
