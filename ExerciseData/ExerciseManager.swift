//
//  ExerciseManager.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/12/24.
//

//Extra comments since more confusing
import Foundation

// Manages and handles exercise data
struct ExerciseManager {
    
    private static let lastFetchKey = "lastExerciseFetchTimestamp"
    private static let exerciseDataKey = "exerciseData"
    
    // Function to fetch exercises from the API
    static func fetchExercises(muscleType: String, completion: @escaping (Result<ExerciseData, Error>) -> Void) {
        print("Calling shouldFetchExercises. \(muscleType)")
        // Check if a day has passed since last fetch
        print("Fetching exercises.")
        // Get API key
        guard let apiKey = APIKeys.shared.apiKey else {
            let error = NSError(domain: "com.yourapp.MealsManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "API key not found"])
            completion(.failure(error))
            return
        }
        // Headers for request
        let headers = [
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": "exercises-by-api-ninjas.p.rapidapi.com"
        ]
        
        // Create request
        let request = NSMutableURLRequest(url: NSURL(string: "https://exercises-by-api-ninjas.p.rapidapi.com/v1/exercises?muscle=\(muscleType)")! as URL,
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
                let error = NSError(domain: "com.yourapp.ExerciseManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                // Decode the received data
                let exercises = try JSONDecoder().decode([Exercise].self, from: data)
                let exerciseData = ExerciseData(exercises: exercises)
                UserDefaults.standard.set(Date(), forKey: lastFetchKey)
                completion(.success(exerciseData))
            } catch {
                // Handle decoding errors
                completion(.failure(error))
            }
        }
        // Resume data task
        dataTask.resume()
    }
}

