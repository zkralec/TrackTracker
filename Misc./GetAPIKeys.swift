//
//  GetAPIKeys.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 6/14/24.
//

import Foundation

struct APIKeys {
    static let shared = APIKeys()

    let apiKey: String?

    private init() {
        if let path = Bundle.main.path(forResource: "apikeys", ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path) as? [String: Any] {
            apiKey = keys["API_KEY"] as? String
        } else {
            apiKey = nil
        }
    }
}
