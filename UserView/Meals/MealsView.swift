//
//  MealsView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/25/24.
//

import SwiftUI

// Page for meal info and user calories
struct MealsView: View {
    @State private var currentPage: Int = 2
    @StateObject var userDataManager = UserDataManager()
    @State private var mealPlan: MealPlan?
    @State private var shouldFetchMealPlan = true
    
    var body: some View {
        if currentPage == 2 {
            VStack {
                // Title
                TitleBackground(title: "Meals")
                
                // Display user information
                Text("Maintenance Calories: \(formatCalories(userDataManager.maintenanceCalories)) kcal / day")
                    .font(.subheadline)
                    .roundedBackground()
                    .padding(.bottom, 20.0)
                
                NavigationStack {
                    // Check if meal plan is fetched
                    if let mealPlan = mealPlan {
                        MealsListView(mealPlan: mealPlan)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button(action: {
                                        fetchRefreshedMeals()
                                    }) {
                                        Image(systemName: "arrow.circlepath")
                                            .frame(width: 10, height: 10)
                                        Text("  Refresh Meals")
                                            .foregroundStyle(Color.blue)
                                            .font(.caption)
                                    }
                                    
                                }
                            }
                    } else {
                        // Loading indicator
                        ProgressView()
                    }
                }
                
                Spacer()
                
                // Navigation buttons
                HStack {
                    VStack {
                        // Exercise button
                        Button(action: {
                            currentPage = 1
                        }) {
                            Image(systemName: "dumbbell.fill")
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .frame(width: 120, height: 40)
                        
                        Text("Exercises")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                    
                    VStack {
                        // Home button
                        Button(action: {
                            currentPage = 3
                        }) {
                            Image(systemName: "house.fill")
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .frame(width: 120, height: 40)
                        
                        Text("Home")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                    
                    VStack {
                        // Workout button
                        Button(action: {
                            currentPage = 0
                        }) {
                            Image(systemName: "figure.run")
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .frame(width: 120, height: 40)
                        
                        Text("Workouts")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(4)
                    }
                }
                .padding()
            }
            .onAppear {
                // Calculate maintenance calories
                userDataManager.calculateMaintenanceCalories()
                // Fetch a meal plan if needed
                fetchMeals()
            }
        } else if currentPage == 1 {
            ExerciseView()
        } else if currentPage == 0 {
            WorkoutView()
        } else if currentPage == 3 {
            HomeView()
        }
    }
    
    // Format calories for no decimal places
    private func formatCalories(_ calories: Double) -> String {
        let caloriesFormatter = NumberFormatter()
        caloriesFormatter.maximumFractionDigits = 0
        return "\(caloriesFormatter.string(from: NSNumber(value: calories)) ?? "")"
    }
    
    // Fetches meal plans if under daily limit
    private func fetchMeals() {
        if shouldFetchMealPlan {
            MealsManager.fetchMealPlans(calories: userDataManager.maintenanceCalories) { result in
                switch result {
                case .success(let fetchedMealPlan):
                    mealPlan = fetchedMealPlan
                    shouldFetchMealPlan = false // Prevent accidental fetching
                case .failure(let error):
                    print("Error fetching meal plan: \(error)")
                }
            }
        }
    }
    
    // Bypasses daily limit of fetching and gets new meals
    private func fetchRefreshedMeals() {
        MealsManager.fetchRefreshedMealPlan(calories: userDataManager.maintenanceCalories) { result in
            switch result {
            case .success(let fetchedMealPlan):
                mealPlan = fetchedMealPlan
            case .failure(let error):
                print("Error fetching meal plan: \(error)")
            }
        }
    }
}

#Preview {
    MealsView()
}
