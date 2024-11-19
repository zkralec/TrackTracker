//
//  MeetData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/18/24.
//

import Foundation

// Holds all meet data variables
struct MeetData: Identifiable, Codable {
    var id = UUID()
    var meetDate: Date
    var meetLocation: String
    var indoorOutdoor: String
    var events: [String]

    // Default preset
    static var `default`: MeetData {
        MeetData(
            meetDate: Date(),
            meetLocation: "SMCM",
            indoorOutdoor: "Outdoor",
            events: ["100 meter", "Pole Vault"]
        )
    }
}
