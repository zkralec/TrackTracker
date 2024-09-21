//
//  InjuryData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 9/21/24.
//

import Foundation

struct InjuryData: Identifiable {
    let id = UUID()
    var injuryDate: Date
    var muscleGroup: String
    var injuryType: String
    var severity: Int
    var location: String
}
