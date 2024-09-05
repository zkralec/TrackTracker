//
//  MealsView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/25/24.
//

import SwiftUI

// Page for meal info and user calories
struct MealsView: View {
    @State private var currPage: Int = 2
    @State private var mealPlan: MealPlan?
    @State private var shouldFetchMealPlan = true
    @State private var isSideMenuOpen = false
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    @StateObject var userDataManager = UserDataManager()
    
    var body: some View {
        if currPage == 2 {
            ZStack {
                VStack {
                    // Menu bar icon
                    MenuButton(isSideMenuOpen: $isSideMenuOpen)
                    
                    // Title
                    TitleBackground(title: "Meals")
                    
                    // Display user information
                    Text("Maintenance Calories: \(formatCalories(userDataManager.maintenanceCalories)) kcal / day")
                        .font(.subheadline)
                        .padding(5)
                        .roundedBackground()
                    
                    // Display helpful info for meal order
                    Text("Breakfast/Lunch/Dinner")
                        .font(.subheadline)
                        .padding(.bottom, 20.0)
                    
                    NavigationStack {
                        // Check if meal plan is fetched
                        if let mealPlan = mealPlan {
                            MealsListView(mealPlan: mealPlan)
                                .toolbar {
                                    ToolbarItem(placement: .topBarTrailing) {
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
                    
                    // Navigation bar buttons
                    VStack {
                        NavigationBar(currPage: $currPage)
                    }
                    .onAppear {
                        // Calculate maintenance calories
                        userDataManager.calculateMaintenanceCalories()
                        // Fetch a meal plan if needed
                        fetchMeals()
                    }
                }
                // Show side menu if needed
                SideBar(currPage: $currPage, isSideMenuOpen: $isSideMenuOpen)
            }
        } else if currPage == 7 {
            ProfileView()
        } else if currPage == 0 {
            WorkoutView()
        } else if currPage == 1 {
            ExerciseView()
        } else if currPage == 3 {
            HomeView()
        } else if currPage == 4 {
            SettingsView()
        } else if currPage == 5 {
            EventView(events: $events)
        } else if currPage == 6 {
            MeetView()
        } else if currPage == 8 {
            TrainingLogView()
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
