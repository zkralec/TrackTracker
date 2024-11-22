//
//  UserModel.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/11/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let team: String
    let fullName: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

extension User {
    static var mockUser = User(id: NSUUID().uuidString, team: "St. Mary's College of Maryland", fullName: "Zack Kralec", email: "test@gmail.com")
}
