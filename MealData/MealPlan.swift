//
//  MealPlan.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/10/24.
//

import Foundation

// Struct for MealPlan
struct MealPlan: Codable {
    var meals: [MealItem]
}

// Struct representing a meal item
struct MealItem: Codable, Identifiable {
    let id: Int
    let readyInMinutes: Int
    let sourceUrl: URL
    let servings: Int
    let title: String
    let imageType: String
}
