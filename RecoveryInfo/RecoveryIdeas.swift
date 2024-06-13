//
//  RecoveryIdeas.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 6/10/24.
//

import Foundation

struct RecoveryIdeas {
    let title: String
    let description: String
}

let recoveryIdeas: [String: [RecoveryIdeas]] = [
    "Great": [RecoveryIdeas(title: "Hydration", description: "Make sure to hydrate well after your workout.")],
    "Good": [RecoveryIdeas(title: "Stretching", description: "Do some light stretching to cool down your muscles.")],
    "Average": [RecoveryIdeas(title: "Foam Rolling", description: "Use a foam roller to relieve muscle tension.")],
    "Poor": [RecoveryIdeas(title: "Rest", description: "Take a rest day to let your body recover.")],
    "Terrible": [RecoveryIdeas(title: "Consult a Trainer", description: "Consider consulting a trainer for advice on your workout routine.")]
]
