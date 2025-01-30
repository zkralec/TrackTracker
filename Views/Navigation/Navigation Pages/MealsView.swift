//
//  MealsView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/25/24.
//

import SwiftUI

// Page for meal info and user calories
struct MealsView: View {
    @State private var mealPlan: MealPlan?
    @State private var shouldFetchMealPlan = false
    @State private var isSideMenuOpen = false
    
    @StateObject var userDataManager = UserDataManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        VStack {
                            HStack {
                                // Manu button
                                MenuButton(isSideMenuOpen: $isSideMenuOpen)
                                
                                Spacer()
                                
                                // Title with Side Menu Button
                                TitleBackground(title: "Daily Meals")
                                
                                Spacer()
                                
                                // Refresh button at the top-right
                                Button(action: {
                                    fetchMeals(isRefreshed: true)
                                }) {
                                    Image(systemName: "arrow.circlepath")
                                        .frame(width: 70, height: 30)
                                }
                            }
                            
                            // Display user information
                            Text("Maintenance Calories: \(formatCalories(userDataManager.maintenanceCalories)) kcal / day")
                                .font(.subheadline)
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                        }
                        .padding(.bottom, 10)
                        
                        // Have to use a weird double VStack to be able to eliminate extra space on the bottom
                        Divider()
                    }
                    .padding(.bottom, -8)
                    
                    List {
                        // Check if meal plan is fetched
                        if let mealPlan = mealPlan {
                            MealsListView(mealPlan: mealPlan)
                        } else if userDataManager.maintenanceCalories == 0 {
                            VStack {
                                Spacer()
                                
                                Text("To get recommended meals, please enter user data in Settings -> Modify User Data")
                                    .foregroundStyle(Color.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Spacer()
                            }
                        } else {
                            // Loading indicator
                            HStack {
                                Spacer()
                                
                                ProgressView()
                                
                                Spacer()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Navigation bar buttons
                    VStack {
                        NavigationBar()
                    }
                    .onAppear {
                        // Calculate maintenance calories
                        userDataManager.calculateMaintenanceCalories()
                        
                        // Fetch a meal plan if needed
                        fetchMeals(isRefreshed: shouldFetchMealPlan)
                    }
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
    
    // Format calories for no decimal places
    private func formatCalories(_ calories: Double) -> String {
        let caloriesFormatter = NumberFormatter()
        caloriesFormatter.maximumFractionDigits = 0
        return "\(caloriesFormatter.string(from: NSNumber(value: calories)) ?? "")"
    }
    
    // Fetches meal plans if a day has passed since last fetch
    private func fetchMeals(isRefreshed: Bool? = nil) {
        MealsManager.fetchMealPlan(calories: userDataManager.maintenanceCalories, isRefreshed: isRefreshed ?? false) { result in
            switch result {
            case .success(let fetchedMealPlan):
                mealPlan = fetchedMealPlan
                shouldFetchMealPlan = false
            case .failure(let error):
                print("Error fetching meal plan: \(error)")
            }
        }
    }
}
