//
//  RecoveryPrompt.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 6/10/24.
//

import SwiftUI

// Appears after the user has completed a workout, will give recovery suggestions
struct RecoveryPrompt: View {
    @Binding var isPresented: Bool
    @Binding var selectedExperience: String?
    
    @Environment(\.colorScheme) var colorScheme
    
    // Whole list of recovery ideas depending on workout difficulty
    let recoveryIdeas: [String: [(title: String, description: String)]] = [
        "Easy": [
            ("Stretching", "Do some light stretching."),
            ("Hydration", "Drink plenty of water."),
            ("Light Activity", "Engage in a low-intensity activity like walking or yoga."),
            ("Sleep", "Ensure you get a good night's sleep.")
        ],
        "Moderate": [
            ("Cool Down", "A gentle cool down walk or jog."),
            ("Hydration", "Drink plenty of water."),
            ("Foam Rolling", "Use a foam roller to relieve muscle tension."),
            ("Light Activity", "Engage in a low-intensity activity like walking or yoga."),
            ("Sleep", "Ensure you get a good night's sleep.")
        ],
        "Medium": [
            ("Cool Down", "A gentle cool down walk or jog."),
            ("Foam Rolling", "Use a foam roller to relieve muscle tension."),
            ("Nutrition", "Have a nutrient-rich meal with a focus on protein and complex carbs."),
            ("Hydration", "Drink plenty of water."),
            ("Massage", "Consider getting a massage to help with muscle recovery."),
            ("Sleep", "Ensure you get a good night's sleep.")
        ],
        "Difficult": [
            ("Cool Down", "A gentle cool down walk or jog."),
            ("Rest", "Take a rest day to let your body recover."),
            ("Ice Bath", "Take an ice bath to reduce inflammation and muscle soreness."),
            ("Hydration", "Drink plenty of water."),
            ("Nutrition", "Have a nutrient-rich meal with a focus on protein and complex carbs."),
            ("Compression", "Wear compression garments to improve blood flow and reduce muscle fatigue."),
            ("Sleep", "Ensure you get a good night's sleep.")
        ],
        "Challenging": [
            ("Cool Down", "A gentle cool down walk or jog."),
            ("Rest", "Take a rest day to let your body recover."),
            ("Ice Bath", "Take an ice bath to reduce inflammation and muscle soreness."),
            ("Compression", "Wear compression garments to improve blood flow and reduce muscle fatigue."),
            ("Hydration", "Drink plenty of water."),
            ("Trainer", "Consider going to your trainer to help aid muscle recovery."),
            ("Nutrition", "Have a nutrient-rich meal with a focus on protein and complex carbs."),
            ("Sleep", "Ensure you get a good night's sleep.")
        ]
    ]
    
    var body: some View {
        VStack {
            // Lets the user choose their workout experience
            if selectedExperience == nil {
                Text("How did your workout feel?")
                    .font(.headline)
                    .padding()
                    .padding(.top, 30)
                
                // Experience options
                ForEach(["Easy", "Moderate", "Medium", "Difficult", "Challenging"], id: \.self) { experience in
                    Button(action: {
                        withAnimation {
                            selectedExperience = experience
                            saveSelectedExperience(experience)
                        }
                    }) {
                        Text(experience)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.blue)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.vertical, 5)
                }
            // Suggestions based on experience will appear in a list
            } else if let experience = selectedExperience, let ideas = recoveryIdeas[experience] {
                Text("Recovery Suggestions")
                    .font(.headline)
                    .padding()
                
                // Formatting for list and suggestions
                GeometryReader { geometry in
                    let maxHeight = geometry.size.height * 1.5
                    List(ideas, id: \.title) { idea in
                        Section {
                            VStack(alignment: .leading) {
                                Text(idea.title)
                                    .font(.headline)
                                Text(idea.description)
                                    .font(.subheadline)
                            }
                            .padding(.horizontal)
                        }
                        .listSectionSpacing(20)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxHeight: maxHeight)
                }
                .padding(.horizontal)
                .background(Color.clear)
            }
            
            Spacer()
            
            // Done button, can also swipe down
            Button(action: {
                isPresented = false
            }) {
                Text("Done")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.blue)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
        }
        .padding()
        .background(colorScheme == .dark ? Color.black.opacity(0.8) : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
        .ignoresSafeArea()
    }
    
    // Saves the experience so it is not reset every time
    private func saveSelectedExperience(_ experience: String) {
        UserDefaults.standard.set(experience, forKey: "SelectedExperience")
        UserDefaults.standard.set(Date(), forKey: "lastExperienceDate")
    }
}
