//
//  InjuryData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 9/21/24.
//

import Foundation

// Holds all injury data variables
struct InjuryData: Identifiable, Codable {
    var id = UUID()
    var injuryDate: Date
    var muscleGroup: String
    var injuryType: String
    var severity: Int
    var location: String
    var allowedActivities: [String]
    var restrictedActivities: [String]

    // Default preset
    static var `default`: InjuryData {
        InjuryData(
            injuryDate: Date(),
            muscleGroup: "Hamstring",
            injuryType: "Strain",
            severity: 1,
            location: "Upper",
            allowedActivities: ["Light Stretching"],
            restrictedActivities: ["Heavy Lifting"]
        )
    }
}
