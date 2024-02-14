//
//  MealsAPI.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/12/24.
//

import Foundation

let headers = [
    "X-RapidAPI-Key": "a50594d3d7mshb43be11145eead9p10e6a2jsndadd722e10f8",
    "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
]

let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/mealplans/generate?timeFrame=day&targetCalories=2000&diet=vegetarian&exclude=shellfish%2C%20olives")! as URL,
                                    cachePolicy: .useProtocolCachePolicy,
                                timeoutInterval: 10.0)
request.httpMethod = "GET"
request.allHTTPHeaderFields = headers

let session = URLSession.shared

do {
    let semaphore = DispatchSemaphore(value: 0)
    let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
        defer {
            semaphore.signal()
        }
        if let error = error {
            print(error)
            return
        }
        let httpResponse = response as? HTTPURLResponse
        print(httpResponse)
    }
    dataTask.resume()
    semaphore.wait()
} catch {
    print(error)
}

