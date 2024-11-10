//
//  WeightsExercise.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/10/24.
//

import Foundation

struct WeightExercise: Codable, Identifiable {
    var id: UUID?
    var exercise: String
    var weight: [String]
    var reps: [String]
    var discTitle: String
    var sets: Int
    
    // Initialize with a new UUID if id is nil
    init(id: UUID? = nil, exercise: String, weight: [String], reps: [String], discTitle: String, sets: Int) {
        self.id = id ?? UUID()
        self.exercise = exercise
        self.weight = weight
        self.reps = reps
        self.discTitle = discTitle
        self.sets = sets
    }
}
