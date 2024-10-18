//
//  ExerciseManager.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/12/24.
//

import Foundation

// Manages and handles exercise data
struct ExerciseManager {
    
    private static let lastFetchKey = "lastExerciseFetchTimestamp"
    private static let exerciseDataKey = "exerciseData"
    
    // Function to fetch exercises from the API
    static func fetchExercises(muscleType: String, completion: @escaping (Result<ExerciseData, Error>) -> Void) {
        print("Calling shouldFetchExercises for muscleType: \(muscleType)")
        print("Fetching exercises from the API.")
        
        // Get API key
        guard let apiKey = APIKeys.shared.apiKey else {
            let error = NSError(domain: "com.yourapp.ExerciseManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "API key not found"])
            completion(.failure(error))
            return
        }
        
        // Headers for request
        let headers = [
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": "exercises-by-api-ninjas.p.rapidapi.com"
        ]
        
        // Create request
        let urlString = "https://exercises-by-api-ninjas.p.rapidapi.com/v1/exercises?muscle=\(muscleType)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "com.yourapp.ExerciseManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        // Perform request
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle network errors
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                // If no data received
                let error = NSError(domain: "com.yourapp.ExerciseManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            // Handles response
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    // Success
                    do {
                        // Decode the received data
                        let exercises = try JSONDecoder().decode([Exercise].self, from: data)
                        let exerciseData = ExerciseData(exercises: exercises)
                        
                        // Cache data
                        cacheExerciseData(exerciseData)
                        
                        // Save the current fetch time
                        UserDefaults.standard.set(Date(), forKey: lastFetchKey)
                        completion(.success(exerciseData))
                    } catch {
                        // Handle decoding errors
                        completion(.failure(error))
                    }
                case 400...499:
                    // Client errors
                    let error = NSError(domain: "com.yourapp.ExerciseManager", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Client error: \(httpResponse.statusCode)"])
                    completion(.failure(error))
                case 500...599:
                    // Server errors
                    let error = NSError(domain: "com.yourapp.ExerciseManager", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error: \(httpResponse.statusCode)"])
                    completion(.failure(error))
                default:
                    // Unexpected status code
                    let error = NSError(domain: "com.yourapp.ExerciseManager", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected response code: \(httpResponse.statusCode)"])
                    completion(.failure(error))
                }
            }
        }
        
        // Resume data task
        dataTask.resume()
    }
    
    // Function to decide if we should use cached data
    private static func shouldUseCachedData() -> Bool {
        if let lastFetchDate = UserDefaults.standard.object(forKey: lastFetchKey) as? Date {
            let now = Date()
            let daysSinceLastFetch = Calendar.current.dateComponents([.day], from: lastFetchDate, to: now).day ?? 0
            return daysSinceLastFetch < 1
        }
        return false
    }
    
    // Cache exercise data
    private static func cacheExerciseData(_ exerciseData: ExerciseData) {
        if let encodedData = try? JSONEncoder().encode(exerciseData) {
            UserDefaults.standard.set(encodedData, forKey: exerciseDataKey)
        }
    }
    
    // Get cached exercise data
    private static func getCachedExerciseData() -> ExerciseData? {
        if let savedData = UserDefaults.standard.data(forKey: exerciseDataKey),
           let decodedData = try? JSONDecoder().decode(ExerciseData.self, from: savedData) {
            return decodedData
        }
        return nil
    }
}
