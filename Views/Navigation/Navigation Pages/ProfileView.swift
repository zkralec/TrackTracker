//
//  AccountInfoView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/25/24.
//

import SwiftUI

// Keeps track of the users personal info
struct ProfileView: View {
    @State private var isSideMenuOpen = false
    @State private var prs = [EventData: String]()
    @State private var userData: UserData?
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    @StateObject var userDataManager = UserDataManager()
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack {
                        // Display title
                        TitleBackground(title: "Profile")
                        
                        HStack {
                            // Menu bar icon
                            MenuButton(isSideMenuOpen: $isSideMenuOpen)
                            Spacer()
                        }
                    }
                    
                    if let user = viewModel.currentUser {
                        List {
                            // User information display section
                            Section("General") {
                                HStack {
                                    Spacer()
                                    
                                    VStack {
                                        // Display user information
                                        HStack {
                                            Text(user.initials)
                                                .font(.title)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color.white)
                                                .frame(width: 72, height: 72)
                                                .background(Color(.systemGray3))
                                                .clipShape(Circle())
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(user.fullName)
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .padding(.top, 4)
                                                
                                                Text(user.email)
                                                    .font(.footnote)
                                                    .foregroundStyle(Color.secondary)
                                            }
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .roundedBackground()
                                        .padding()
                                        
                                        if let userData = userDataManager.userData {
                                            HStack {
                                                VStack(alignment: .trailing, spacing: 4) {
                                                    Text("Height: \(userData.heightFeet)' \(userData.heightInches)\"")
                                                        .font(.subheadline)
                                                        .padding(5)
                                                        .roundedBackground()
                                                    Text("Weight: \(formatWeight(userData.weight))")
                                                        .font(.subheadline)
                                                        .padding(5)
                                                        .roundedBackground()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Age: \(userData.age + 18)")
                                                        .font(.subheadline)
                                                        .padding(5)
                                                        .roundedBackground()
                                                    Text("Gender: \(userData.gender.rawValue)")
                                                        .font(.subheadline)
                                                        .padding(5)
                                                        .roundedBackground()
                                                }
                                            }
                                        } else {
                                            Text("To get more user info displayed, go to Settings -> Modify User Data")
                                                .foregroundStyle(Color.secondary)
                                                .multilineTextAlignment(.center)
                                                .padding()
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.bottom)
                            }
                            .listSectionSpacing(15)
                            
                            // User can see main events and their PR
                            Section("Personal Records") {
                                VStack {
                                    if events.isEmpty {
                                        HStack {
                                            Spacer()
                                            
                                            Text("No selected events")
                                                .foregroundStyle(.secondary)
                                                .padding()
                                            
                                            Spacer()
                                        }
                                    } else {
                                        // Go and get each event and pr for that event (if any)
                                        ForEach(events, id: \.self) { event in
                                            if let record = prs[event], !record.isEmpty {
                                                HStack {
                                                    Text(event.rawValue)
                                                    Spacer()
                                                    Text(record)
                                                }
                                                .padding(.vertical, 4)
                                            } else {
                                                HStack {
                                                    Text(event.rawValue)
                                                    Spacer()
                                                    Text("Enter in Settings")
                                                        .foregroundStyle(.secondary)
                                                }
                                                .padding(.vertical, 4)
                                            }
                                        }
                                    }
                                }
                                .onAppear {
                                    loadPR()
                                }
                                .padding()
                            }
                            .listSectionSpacing(15)
                        }
                    }
                    // Navigation bar buttons
                    NavigationBar()
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
    
    // Format weight to display with correct units
    private func formatWeight(_ weight: Double) -> String {
        let weightFormatter = NumberFormatter()
        weightFormatter.maximumFractionDigits = weight.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 1
        return "\(weightFormatter.string(from: NSNumber(value: weight)) ?? "") lbs"
    }
    
    // Load the user's event PRs
    func loadPR() {
        for event in events {
            if let prValue = UserDefaults.standard.string(forKey: event.rawValue) {
                prs[event] = prValue
            }
        }
    }
}
