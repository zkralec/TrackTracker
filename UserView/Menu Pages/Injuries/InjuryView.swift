//
//  InjuryView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 9/19/24.
//

import SwiftUI

struct InjuryView: View {
    @State private var currPage: Int = 9
    @State private var isSideMenuOpen = false
    
    var body: some View {
        if currPage == 9 {
            ZStack {
                VStack {
                    // Menu bar icon
                    MenuButton(isSideMenuOpen: $isSideMenuOpen)
                    
                    TitleBackground(title: "Injury Log")
                    
                    Button(action: {
                        withAnimation {
                            currPage = 10
                        }
                    }) {
                        Text("Add an Injury")
                    }
                    .padding(.top, 10)
                    
                    // Add content here
                    List {
                        Text("Placeholder")
                        
                        // Have a button to add a new injury.
                        // Take user to new page to create new injury?
                        
                        // Want to have dropdown for muscle injury group. ex. hamstring, shins, quads, etc.
                        // Have another dropdown after with injuries for that muscle group.
                        // Have a wheel for the date.
                        // Have a status dropdown for active, recovering, recovered.
                        
                        // Show some treatment options. ex. stretches, ice, compression, cupping, etc.
                        // Add a timeline to predict full recovery depending on the severity.
                        // Add restrictions for things you should not do while injured.
                    }
                }
                // Show side menu if needed
                SideBar(currPage: $currPage, isSideMenuOpen: $isSideMenuOpen)
            }
            
        } else if currPage == 3 {
            HomeView()
        } else if currPage == 4 {
            SettingsView()
        } else if currPage == 6 {
            MeetView()
        } else if currPage == 7 {
            ProfileView()
        } else if currPage == 8 {
            TrainingLogView()
        } else if currPage == 10 {
            InjuryDetailView()
        }
    }
}
