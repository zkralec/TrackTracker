//
//  MealsManager.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/10/24.
//

import Foundation

// Struct for managing meal plans with steps to avoid exceeding daily API fetch limit
struct MealsManager {
    
    // UserDefaults keys
    private static let lastFetchKey = "lastFetchTimestamp"
    private static let mealPlanKey = "mealPlan"
    
    // Function to fetch meal plans (can bypass with refresh button)
    static func fetchMealPlan(calories: Double, isRefreshed: Bool? = false, completion: @escaping (Result<MealPlan, Error>) -> Void) {
        print("Fetching meal plan.")
        
        // Check if we should fetch a new meal plan or load
        if !(isRefreshed ?? false) {
            print("Loading stored meal plan.")
            loadStoredMealPlan(completion: completion)
            return
        }
        
        // Check if we bypass loading past meals with isRefreshed
        if isRefreshed ?? false {
            print("Fetching a new meal plan bypassing stored data.")
            loadMealPlanFromAPI(calories: calories, completion: completion)
            return
        }
        
        // Fetch from API if necessary
        guard let apiKey = APIKeys.shared.apiKey else {
            completion(.failure(MealsManagerError.apiKeyNotFound))
            return
        }
        
        let headers = [
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]
        
        // Create request for fetching meal plan
        let request = createRequest(with: calories, headers: headers)
        
        // Perform request and handle response
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            handleResponse(data: data, error: error, completion: completion)
        }
        dataTask.resume()
    }
    
    // Handle loading meal plans from the API with bypass
    private static func loadMealPlanFromAPI(calories: Double, completion: @escaping (Result<MealPlan, Error>) -> Void) {
        guard let apiKey = APIKeys.shared.apiKey else {
            completion(.failure(MealsManagerError.apiKeyNotFound))
            return
        }
        
        let headers = [
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]
        
        // Create request for fetching meal plan
        let request = createRequest(with: calories, headers: headers)
        
        // Perform request and handle response
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            handleResponse(data: data, error: error, completion: completion)
        }
        dataTask.resume()
    }
    
    // Create HTTP request for the API
    private static func createRequest(with calories: Double, headers: [String: String]) -> NSMutableURLRequest {
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/mealplans/generate?timeFrame=day&targetCalories=3900"
        let url = URL(string: urlString)!
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    // Handle response from the API request
    private static func handleResponse(data: Data?, error: Error?, completion: @escaping (Result<MealPlan, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(MealsManagerError.noDataReceived))
            return
        }
        
        do {
            // Decode the received data
            let mealPlan = try JSONDecoder().decode(MealPlan.self, from: data)
            storeMealPlan(mealPlan)
            completion(.success(mealPlan))
        } catch {
            completion(.failure(MealsManagerError.decodingFailed))
        }
    }
    
    // Store fetched meal plan
    private static func storeMealPlan(_ mealPlan: MealPlan) {
        if let encodedData = try? JSONEncoder().encode(mealPlan) {
            UserDefaults.standard.set(encodedData, forKey: mealPlanKey)
            print("Saved meal plan.")
        } else {
            print("Failed to encode meal plan data")
        }
    }
    
    // Load stored meal plan if API fetch is unnecessary
    private static func loadStoredMealPlan(completion: @escaping (Result<MealPlan, Error>) -> Void) {
        if let storedMealPlanData = UserDefaults.standard.data(forKey: mealPlanKey),
           let storedMealPlan = try? JSONDecoder().decode(MealPlan.self, from: storedMealPlanData) {
            completion(.success(storedMealPlan))
        } else {
            completion(.failure(MealsManagerError.decodingFailed))
        }
    }
    
    // Decide if we need to fetch new meal plan
    private static func shouldFetchMealPlan() -> Bool {
        guard let lastFetchDate = UserDefaults.standard.object(forKey: lastFetchKey) as? Date else {
            print("shouldFetchMealPlan: true (no previous fetch found).")
            return true
        }
        let shouldFetch = !Calendar.current.isDateInToday(lastFetchDate)
        print("shouldFetchMealPlan: \(shouldFetch ? "true" : "false").")
        return shouldFetch
    }
    
    // Handle different error cases
    enum MealsManagerError: Error {
        case apiKeyNotFound
        case noDataReceived
        case decodingFailed
        
        var localizedDescription: String {
            switch self {
            case .apiKeyNotFound:
                return "API key not found."
            case .noDataReceived:
                return "No data received from the server."
            case .decodingFailed:
                return "Failed to decode the meal plan data."
            }
        }
    }
}
