//
//  MealsManager.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/10/24.
//

//Extra comments since more confusing
import Foundation

// Struct for managing meal plans (DO NOT WANT TO REACH DAILY FETCH LIMIT OF 50 so extra steps taken to avoid that)

struct MealsManager {
    
    // Keys
    private static let lastFetchKey = "lastFetchTimestamp"
    private static let mealPlanKey = "mealPlan"
    
    // Function to fetch meal plans from the API
    static func fetchMealPlans(calories: Double, completion: @escaping (Result<MealPlan, Error>) -> Void) {
        print("Calling shouldFetchMealPlan.")
        // Check if a day has passed since last fetch
        if shouldFetchMealPlan() {
            print("Fetching meal plan.")
            // Headers for request
            let headers = [
                "X-RapidAPI-Key": "a50594d3d7mshb43be11145eead9p10e6a2jsndadd722e10f8",
                "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
            ]
            // Create request
            let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/mealplans/generate?timeFrame=day&targetCalories=\(calories)")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            // Perform request
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if let error = error {
                    // Handle network errors
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    // No data received
                    let error = NSError(domain: "com.yourapp.MealsManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    completion(.failure(error))
                    return
                }

                do {
                    // Decode the received data into MealPlan
                    let mealPlan = try JSONDecoder().decode(MealPlan.self, from: data)
                    storeMealPlan(mealPlan)
                    UserDefaults.standard.set(Date(), forKey: lastFetchKey)
                    completion(.success(mealPlan))
                } catch {
                    // Handle decoding errors
                    completion(.failure(error))
                }
            }
            // Resume data task
            dataTask.resume()
            
            // Update last fetch time
            UserDefaults.standard.set(Date(), forKey: lastFetchKey)
        } else {
            print("Loading stored meal plan.")
            // Retrieve exercises if a day hasn't passed since last fetch
            if let storedMealPlanData = UserDefaults.standard.data(forKey: mealPlanKey),
               let storedMealPlan = try? JSONDecoder().decode(MealPlan.self, from: storedMealPlanData) {
                completion(.success(storedMealPlan))
            } else {
                // No meal plan data found or decoding error
                let error = NSError(domain: "com.yourapp.MealsManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode stored meal plan data"])
                completion(.failure(error))
            }
        }
    }
    
    // Function to fetch refreshed meal plan without daily limit
    static func fetchRefreshedMealPlan(calories: Double, completion: @escaping (Result<MealPlan, Error>) -> Void) {
        print("Fetching refreshed meal plan.")
        // Headers for request
        let headers = [
            "X-RapidAPI-Key": "a50594d3d7mshb43be11145eead9p10e6a2jsndadd722e10f8",
            "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]
        // Create request
        let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/mealplans/generate?timeFrame=day&targetCalories=\(calories)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        // Perform request
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                // Handle network errors
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                // No data received
                let error = NSError(domain: "com.yourapp.MealsManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }

            do {
                // Decode the received data into MealPlan
                let mealPlan = try JSONDecoder().decode(MealPlan.self, from: data)
                storeMealPlan(mealPlan)
                UserDefaults.standard.set(Date(), forKey: lastFetchKey)
                completion(.success(mealPlan))
            } catch {
                // Handle decoding errors
                completion(.failure(error))
            }
        }
        // Resume data task
        dataTask.resume()
    }
    
    // Figure out if a new fetch is needed
    private static func shouldFetchMealPlan() -> Bool {
        if let lastFetchDate = UserDefaults.standard.object(forKey: lastFetchKey) as? Date {
            print("shouldFetchMealPlan: false.")
            // Check if a day has passed since last fetch
            return !Calendar.current.isDateInToday(lastFetchDate)
        }
        print("shouldFetchMealPlan: true.")
        // If no stored time then fetch
        return true
    }
    
    // Store fetched meal plan
    private static func storeMealPlan(_ mealPlan: MealPlan) {
        if let encodedData = try? JSONEncoder().encode(mealPlan) {
            UserDefaults.standard.set(encodedData, forKey: mealPlanKey)
            print("Saved meal plan.")
        } else {
            // Failed to encode meal plan data
            print("Failed to encode meal plan data")
        }
    }
}

