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
            Section(header: Text(mealTitles[index])) {  // Use the title based on index
                VStack(alignment: .leading) {
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
            .listSectionSpacing(10)
        }
    }
}
