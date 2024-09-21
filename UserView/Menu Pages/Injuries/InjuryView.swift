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
    
    @State private var injuryLog: [InjuryData] = []
    @State private var isPresentingInjuryDetail = false
    
    var body: some View {
        if currPage == 9 {
            ZStack {
                VStack {
                    // Menu bar icon
                    MenuButton(isSideMenuOpen: $isSideMenuOpen)
                    
                    TitleBackground(title: "Injury Log")
                    
                    // Add new injury button
                    Button(action: {
                        withAnimation {
                            isPresentingInjuryDetail = true
                        }
                    }) {
                        Text("Add New Injury")
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(CustomButtonStyle())
                    
                    List {
                        // Injuries Section
                        Section(header: Text("Injuries")) {
                            if injuryLog.isEmpty {
                                HStack {
                                    Spacer()
                                    Text("No injuries logged yet.")
                                        .foregroundStyle(.secondary)
                                        .padding()
                                    Spacer()
                                }
                            } else {
                                ForEach(injuryLog) { injury in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("\(injury.muscleGroup)")
                                                .font(.headline)
                                            Text("Date: \(injury.injuryDate, style: .date)")
                                            Text("Type: \(injury.injuryType)")
                                            Text("Severity: \(injury.severity)")
                                        }
                                        Spacer()
                                        Button("Edit") {
                                            isPresentingInjuryDetail = true
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                    .listSectionSpacing(15)
                    .sheet(isPresented: $isPresentingInjuryDetail) {
                        InjuryDetailView()
                    }
                    
                    // Navigation bar buttons
                    VStack {
                        NavigationBar(currPage: $currPage)
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
        }
    }
}
