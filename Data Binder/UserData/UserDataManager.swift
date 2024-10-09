//
//  UserDataManager.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/16/24.
//

import Foundation

// Manages the user data
class UserDataManager: ObservableObject {
    @Published var userData: UserData?
    @Published var maintenanceCalories: Double = 0
    
    static let shared = UserDataManager()
    private let userDefaults = UserDefaults.standard
    
    init() {
        userData = UserData.loadUserData()
    }
    
    // Calculates the average maintenance calories of the user
    func calculateMaintenanceCalories() {
        guard let userData = userData else {
            maintenanceCalories = 0.0
            return
        }
        
        // Convert weight and height
        let weightInKg = userData.weight * 0.453592
        let heightInCm = (Double(userData.heightFeet * 12) + Double(userData.heightInches)) * 2.54
        
        let bmr: Double
        let genderMultiplier: Double
        
        if userData.gender == .male {
            bmr = 88.362 + (13.397 * weightInKg) + (4.799 * heightInCm) - (5.677 * Double(userData.age))
            genderMultiplier = 1.0
        } else {
            bmr = 447.593 + (9.247 * weightInKg) + (3.098 * heightInCm) - (4.330 * Double(userData.age))
            genderMultiplier = 0.9
        }
        
        // BMR * 1.725 because we assume track athletes are very active
        let maintenanceCalories = bmr * 1.725 * genderMultiplier
        
        self.maintenanceCalories = maintenanceCalories
    }
}
