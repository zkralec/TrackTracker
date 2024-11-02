//
//  WeightsView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/1/24.
//

import SwiftUI

struct WeightsView: View {
    @State private var isSideMenuOpen = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack {
                        // Display title
                        TitleBackground(title: "Weights")
                        
                        HStack {
                            // Menu bar icon
                            MenuButton(isSideMenuOpen: $isSideMenuOpen)
                            
                            Spacer()
                            
                            NavigationLink {
                                ExerciseView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                Image(systemName: "info.circle")
                                    .frame(width: 70, height: 30)
                            }
                        }
                    }
                    
                    List {
                        // Add weights info here:
                        // Exercise
                        // Reps
                        // Sets
                        // Weight
                    }
                    
                    // Navigation bar buttons
                    NavigationBar()
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
}

#Preview {
    WeightsView()
}
