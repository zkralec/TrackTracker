//
//  MealsListView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/10/24.
//

import SwiftUI

// Formats the fetched meal data
struct MealsListView: View {
    var mealPlan: MealPlan
    let mealTitles = ["Breakfast", "Lunch", "Dinner"]
    
    var body: some View {
        // Use the indices to map meals and titles
        ForEach(mealPlan.meals.indices, id: \.self) { index in
            Section {
                VStack(alignment: .leading) {
                    // Meal time title
                    Text(mealTitles[index])
                        .padding(.bottom, 4)
                        .underline()
                        .bold()
                    
                    // Meal title
                    Text(mealPlan.meals[index].title)
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    // Ready time
                    Text("Ready in: \(mealPlan.meals[index].readyInMinutes) minutes")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    // Servings
                    Text("Servings: \(mealPlan.meals[index].servings)")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    // Link to food details
                    Link("View Details", destination: mealPlan.meals[index].sourceUrl)
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .underline()
                        .padding(.top, 4)
                }
                .padding()
            }
            .listSectionSpacing(15)
        }
    }
}
