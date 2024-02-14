//
//  ExerciseData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/12/24.
//

import Foundation

// Struct for exercise data
struct ExerciseData: Codable {
    let exercises: [Exercise]
}

// Struct representing an exercise
struct Exercise: Codable, Hashable {
    let name: String
    let equipment: String
    let difficulty: String
    let instructions: String
}
