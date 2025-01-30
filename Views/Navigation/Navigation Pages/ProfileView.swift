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
    @State private var userData: UserData?
    @State private var prs = [EventData: String]()
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Title with Side Menu Button
                    TitleModelView(title: "Profile", menu: true, isSideMenuOpen: $isSideMenuOpen)
                    
                    List {
                        // Next Meet Countdown Card
                        if let user = viewModel.currentUser {
                            Section {
                                AccountCard(user: user)
                            }
                        }
                        
                        // User Data Card
                        Section {
                            UserDataCard()
                        }
                        
                        // Personal Record Card
                        Section {
                            PersonalRecordCard()
                        }
                    }
                    .listSectionSpacing(15)
                
                    // Navigation bar buttons
                    NavigationBar()
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
}

// MARK: - Account Card
struct AccountCard: View {
    let user: User
    
    var body: some View {
        // Display user account information
        HStack {
            Spacer()
            VStack {
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
            }
            .padding()
            .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

// MARK: - User Data Card
struct UserDataCard: View {
    @StateObject var userDataManager = UserDataManager()
    
    var body: some View {
        VStack {
            Text("User Data")
                .font(.headline)
                .padding(.bottom, 5)
            
            VStack {
                if let userData = userDataManager.userData {
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Height: \(userData.heightFeet)' \(userData.heightInches)\"")
                                .font(.subheadline)
                                .padding(5)
                            Text("Weight: \(formatWeight(userData.weight))")
                                .font(.subheadline)
                                .padding(5)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Age: \(userData.age + 18)")
                                .font(.subheadline)
                                .padding(5)
                            Text("Gender: \(userData.gender.rawValue)")
                                .font(.subheadline)
                                .padding(5)
                        }
                        Spacer()
                    }
                } else {
                    HStack {
                        Spacer()
                        Text("To get more user info displayed, go to Settings -> Modify User Data")
                            .foregroundStyle(Color.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    }
                }
            }
            .roundedBackground()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    // Format weight to display with correct units
    private func formatWeight(_ weight: Double) -> String {
        let weightFormatter = NumberFormatter()
        weightFormatter.maximumFractionDigits = weight.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 1
        return "\(weightFormatter.string(from: NSNumber(value: weight)) ?? "") lbs"
    }
}

// MARK: - Personal Record Card
struct PersonalRecordCard: View {
    @State private var prs = [EventData: String]()
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    var body: some View {
        VStack {
            Text("Personal Records")
                .font(.headline)
                .padding(.bottom, 5)
            
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
            .roundedBackground()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .onAppear {
            loadPR()
        }
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
