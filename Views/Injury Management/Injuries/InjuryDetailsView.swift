//
//  InjuryDetailsView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 9/21/24.
//

import SwiftUI

struct InjuryDetailsView: View {
    var injury: InjuryData
    @Binding var injuryLog: [InjuryData]
    
    var body: some View {
        VStack {
            // Title
            TitleBackground(title: "Injury Details")
                .padding(.top, -37)
            
            List {
                // Injury details section
                Section("Injury Information") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Muscle Group: \(injury.muscleGroup)")
                        Text("Injury Type: \(injury.injuryType)")
                        Text("Location: \(injury.location)")
                        Text("Severity: \(injury.severity) / 5")
                    }
                    .padding(10)
                }
                .listSectionSpacing(15)
                
                // Suggested activities section
                Section("Suggested Activities") {
                    Text(getSuggestedActivities(muscleGroup: injury.muscleGroup, injuryType: injury.injuryType))
                        .padding(10)
                }
                .listSectionSpacing(15)
                
                // Restricted activities section
                Section("Restricted Activities") {
                    Text(getRestrictedActivities(muscleGroup: injury.muscleGroup, injuryType: injury.injuryType))
                        .padding(10)
                }
                .listSectionSpacing(15)
                
                // Recommended exercises section
                Section("Recommended Exercises") {
                    Text(getRecommendedExercises(muscleGroup: injury.muscleGroup, injuryType: injury.injuryType))
                        .padding(10)
                }
                .listSectionSpacing(15)
            }
        }
    }
    
    // Function to get suggested activities
    func getSuggestedActivities(muscleGroup: String, injuryType: String) -> String {
        switch (muscleGroup, injuryType) {
        case ("Hamstring", "Strain"): return "Light jogging, cycling, stretching"
        case ("Hamstring", "Tear"): return "Walking, swimming, yoga"
        case ("Hamstring", "Tendinitis"): return "Cycling, swimming, light stretching"
        case ("Quads", "Strain"): return "Cycling, walking, stretching"
        case ("Quads", "Tear"): return "Walking, swimming, yoga"
        case ("Quads", "Tendinitis"): return "Swimming, light cycling, stretching"
        case ("Calves", "Strain"): return "Walking, light stretching, cycling"
        case ("Calves", "Tear"): return "Swimming, light walking, yoga"
        case ("Calves", "Sprain"): return "Walking, stationary cycling, swimming"
        case ("Shins", "Shin Splints"): return "Swimming, cycling, elliptical"
        case ("Shins", "Stress Fracture"): return "Swimming, cycling, stretching"
        case ("Lower Back", "Strain"): return "Walking, swimming, stretching"
        case ("Lower Back", "Sprain"): return "Walking, light stretching, yoga"
        case ("Hip Flexor", "Strain"): return "Walking, cycling, light yoga"
        case ("Hip Flexor", "Tendinitis"): return "Cycling, swimming, stretching"
        case ("Glutes", "Strain"): return "Walking, swimming, stretching"
        case ("Glutes", "Tendinitis"): return "Cycling, swimming, yoga"
        case ("Elbow", "Tendinitis"): return "Light stretching, resistance band exercises, swimming"
        case ("Elbow", "Strain"): return "Light stretching, cycling, walking"
        case ("Elbow", "Ligament Tear"): return "Swimming, resistance band exercises, light stretching"
        case ("Elbow", "Bursitis"): return "Swimming, light stretching, low-impact cardio"
        case ("Achilles Tendon", "Tendinitis"): return "Cycling, swimming, walking"
        case ("Achilles Tendon", "Rupture"): return "Swimming, gentle stretching, stationary cycling"
        case ("Knee", "Patellar Tendinitis"): return "Swimming, cycling, gentle yoga"
        case ("Knee", "ACL/MCL Sprain"): return "Swimming, stationary biking, walking"
        case ("Knee", "Meniscus Tear"): return "Cycling, walking, gentle swimming"
        case ("Ankle", "Inversion Sprain"): return "Swimming, stationary cycling, walking"
        case ("Ankle", "Eversion Sprain"): return "Cycling, swimming, stretching"
        case ("Ankle", "High Ankle Sprain"): return "Gentle stretching, walking, swimming"
        case ("IT Band", "Inflammation"): return "Cycling, gentle yoga, swimming"
        case ("IT Band", "Tendinitis"): return "Swimming, cycling, stretching"
        default: return "Consult your athletic trainer"
        }
    }
    
    // Function to get restricted activities
    func getRestrictedActivities(muscleGroup: String, injuryType: String) -> String {
        switch (muscleGroup, injuryType) {
        case ("Hamstring", "Strain"): return "Sprinting, jumping, weightlifting"
        case ("Hamstring", "Tear"): return "Sprinting, heavy squatting, lunges"
        case ("Hamstring", "Tendinitis"): return "Sprinting, running, jumping"
        case ("Quads", "Strain"): return "Squatting, sprinting, leg press"
        case ("Quads", "Tear"): return "Squatting, jumping, lunges"
        case ("Quads", "Tendinitis"): return "Sprinting, jumping, heavy squats"
        case ("Calves", "Strain"): return "Running, jumping, sprinting"
        case ("Calves", "Tear"): return "Sprinting, jumping, heavy lifting"
        case ("Calves", "Sprain"): return "Running, jumping, hiking"
        case ("Shins", "Shin Splints"): return "Running, jumping, high-impact activities"
        case ("Shins", "Stress Fracture"): return "Running, jumping, sprinting"
        case ("Lower Back", "Strain"): return "Heavy lifting, twisting motions, sprinting"
        case ("Lower Back", "Sprain"): return "Running, weightlifting, bending activities"
        case ("Hip Flexor", "Strain"): return "Sprinting, high-knees, lunges"
        case ("Hip Flexor", "Tendinitis"): return "Sprinting, heavy squatting, lunges"
        case ("Glutes", "Strain"): return "Squatting, sprinting, jumping"
        case ("Glutes", "Tendinitis"): return "Running, jumping, heavy weightlifting"
        case ("Elbow", "Tendinitis"): return "Throwing, weightlifting, push-ups"
        case ("Elbow", "Strain"): return "Throwing, weightlifting, push-ups"
        case ("Elbow", "Ligament Tear"): return "Throwing, weightlifting, push-ups"
        case ("Elbow", "Bursitis"): return "Contact sports, weightlifting, push-ups"
        case ("Achilles Tendon", "Tendinitis"): return "Running, jumping, heavy lifting"
        case ("Achilles Tendon", "Rupture"): return "Running, high-impact activities, jumping"
        case ("Knee", "Patellar Tendinitis"): return "Running, jumping, squatting"
        case ("Knee", "ACL/MCL Sprain"): return "Running, jumping, high-impact sports"
        case ("Knee", "Meniscus Tear"): return "Sprinting, jumping, heavy lifting"
        case ("Ankle", "Inversion Sprain"): return "Running, jumping, heavy weightlifting"
        case ("Ankle", "Eversion Sprain"): return "Sprinting, jumping, hiking"
        case ("Ankle", "High Ankle Sprain"): return "Running, jumping, squatting"
        case ("IT Band", "Inflammation"): return "Running, jumping, high-impact sports"
        case ("IT Band", "Tendinitis"): return "Sprinting, jumping, weightlifting"
        default: return "Consult your athletic trainer"
        }
    }
    
    // Function to get helpful exercises/stretches
    func getRecommendedExercises(muscleGroup: String, injuryType: String) -> String {
        switch (muscleGroup, injuryType) {
        case ("Hamstring", "Strain"): return "- Hamstring stretches\n- Leg raises\n- Foam rolling"
        case ("Hamstring", "Tear"): return "- Gentle yoga\n- Hamstring stretching\n- Isometric exercises"
        case ("Hamstring", "Tendinitis"): return "- Calf stretches\n- Hamstring stretches\n- Low-impact leg exercises"
        case ("Quads", "Strain"): return "- Quad stretches\n- Wall sits\n- Isometric quad exercises"
        case ("Quads", "Tear"): return "- Light stretching\n- Seated leg lifts\n- Gentle yoga"
        case ("Quads", "Tendinitis"): return "- Static stretching\n- Quad strengthening\n- Foam rolling"
        case ("Calves", "Strain"): return "- Calf raises\n- Light calf stretches\n- Seated toe raises"
        case ("Calves", "Tear"): return "- Seated calf stretches\n- Ankle rotations\n- Gentle toe flexion exercises"
        case ("Calves", "Sprain"): return "- Calf stretches\n- Standing calf raises\n- Ankle mobility exercises"
        case ("Shins", "Shin Splints"): return "- Toe raises\n- Foam rolling\n- Shin stretches"
        case ("Shins", "Stress Fracture"): return "- Ankle circles\n- Swimming\n- Stretching for lower leg muscles"
        case ("Lower Back", "Strain"): return "- Cat-Cow stretch\n- Child's pose\n- Pelvic tilts"
        case ("Lower Back", "Sprain"): return "- Gentle yoga\n- Knee-to-chest stretch\n- Seated forward bend"
        case ("Hip Flexor", "Strain"): return "- Hip flexor stretches\n- Seated leg lifts\n- Hip bridges"
        case ("Hip Flexor", "Tendinitis"): return "- Gentle lunges\n- Standing hip flexor stretches\n- Cycling"
        case ("Glutes", "Strain"): return "- Glute bridges\n- Hip abduction\n- Clamshell exercises"
        case ("Glutes", "Tendinitis"): return "- Glute stretches\n- Foam rolling\n- Light yoga"
        case ("Elbow", "Tendinitis"): return "- Wrist flexor stretches\n- Eccentric wrist exercises\n- Forearm rolling"
        case ("Elbow", "Strain"): return "- Gentle elbow flexion\n- Bicep curls with light resistance\n- Grip strengthening exercises"
        case ("Elbow", "Ligament Tear"): return "- Isometric elbow exercises\n- Wrist flexion and extension exercises"
        case ("Elbow", "Bursitis"): return "- Gentle elbow stretches\n- Wrist stretches\n- Grip strengthening exercises"
        case ("Achilles", "Tendinitis"): return "- Heel raises\n- Calf stretches\n- Eccentric heel drops"
        case ("Achilles", "Rupture"): return "- Ankle mobility exercises\n- Seated calf stretches\n- Toe raises"
        case ("Knee", "Patellar Tendinitis"): return "- Quad stretches\n- Wall sits\n- Straight leg raises"
        case ("Knee", "ACL/MCL Sprain"): return "- Quad sets\n- Hamstring curls\n- Glute bridges"
        case ("Knee", "Meniscus Tear"): return "- Leg presses with light resistance\n- Cycling\n- Hamstring stretches"
        case ("Ankle", "Inversion Sprain"): return "- Ankle circles\n- Calf raises\n- Resistance band exercises"
        case ("Ankle", "Eversion Sprain"): return "- Toe raises\n- Ankle rotations\n- Standing calf stretches"
        case ("Ankle", "High Ankle Sprain"): return "- Toe flexion\n- Calf stretches\n- Resistance band ankle exercises"
        case ("IT Band", "Inflammation"): return "- IT band foam rolling\n- Side leg raises\n- Gentle hip stretches"
        case ("IT Band", "Tendinitis"): return "- IT band stretches\n- Glute strengthening\n- Side-lying hip abduction"
        default: return "Consult your athletic trainer"
        }
    }
}
