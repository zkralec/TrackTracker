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
    
    var body: some View {
        List {
            ForEach(mealPlan.meals) { meal in
                Section {
                    VStack(alignment: .leading) {
                        // Meal title
                        Text(meal.title)
                            .font(.headline)
                            .padding(.bottom, 4)
                        
                        // Ready time
                        Text("Ready in: \(meal.readyInMinutes) minutes")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        // Servings
                        Text("Servings: \(meal.servings)")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        // Link to food details
                        Link("View Details", destination: meal.sourceUrl)
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
        .padding(.top, -35)
        .background(Color.gray.opacity(0.05))
    }
}
