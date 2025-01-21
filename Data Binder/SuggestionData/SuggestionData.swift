//
//  SuggestionData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 1/21/25.
//

import Foundation

func getSuggestedData (randomInt: Int) -> String {
    let suggestionOptions = [
        0: "Do some stationary stretches and roll out.",
        1: "Visit your trainer if your body feels hurt.",
        2: "Eat a balanced diet and make sure you get enough protein.",
        3: "If you are feeling low on energy make sure to sleep at an earlier time.",
        4: "Make sure to cool down properly. It helps prevent muscle fatigue and injury."
    ]
    
    // Default suggestion
    return suggestionOptions[randomInt] ?? "Listen to your body and decide whether to rest or stretch."
}
