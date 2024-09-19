//
//  InjuryView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 9/19/24.
//

import SwiftUI

struct InjuryView: View {
    @State private var currPage: Int = 9
    
    var body: some View {
        if currPage == 9 {
            
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
        }
    }
}
