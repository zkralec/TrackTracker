import SwiftUI

// Main page for the user, shows a variety of info
struct HomeView: View {
    @State private var currPage: Int = 3
    @State private var isSideMenuOpen = false
    @State private var prs = [EventData: String]()
    @State private var meets: [Date] = []
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    var body: some View {
        if currPage == 3 {
            ZStack {
                VStack {
                    // Menu bar icon
                    MenuButton(isSideMenuOpen: $isSideMenuOpen)
                    
                    // Display title
                    TitleBackground(title: "Home")
                    
                    List {
                        // Current streak of tracking workouts
                        Section {
                            HStack {
                                Spacer()
                                
                                VStack {
                                    Text("Current Streak")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.primary)
                                        .padding(.top, 20)
                                    
                                    Text("\(StreakData.streakCount())")
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundStyle(.primary)
                                        .padding(.bottom, 20)
                                        .padding(.top, 5)
                                }
                                
                                Spacer()
                            }
                        }
                        .listSectionSpacing(15)
                        
                        // User can see main events and their PR
                        Section {
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
                                    Text("Personal Records")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .padding(.bottom, 8)
                                    
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
                                                Spacer()
                                                
                                                Text("No personal record set for \(event.rawValue)")
                                                    .foregroundStyle(.secondary)
                                                    .padding(.vertical, 4)
                                                
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .listSectionSpacing(15)
                        
                        // Display meet dates
                        Section {
                            HStack {
                                Spacer()
                                
                                VStack {
                                    Text("Meet Days")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .padding(.bottom,8)
                                    
                                    if meets.isEmpty {
                                        Text("No meet days selected")
                                            .foregroundStyle(.secondary)
                                            .padding()
                                            .roundedBackground()
                                    } else {
                                        ForEach(meets, id: \.self) { date in
                                            Text(date.formatted())
                                                .padding(5)
                                                .roundedBackground()
                                        }
                                    }
                                }
                                .onAppear {
                                    loadPR()
                                    loadMeets()
                                }
                                .padding()
                                
                                Spacer()
                            }
                        }
                        .listSectionSpacing(15)
                    }
                    .background(Color(.systemGray6).opacity(0.05))
                    
                    // Navigation bar buttons
                    VStack {
                        NavigationBar(currPage: $currPage)
                    }
                }
                // Show side menu if needed
                SideBar(currPage: $currPage, isSideMenuOpen: $isSideMenuOpen)
            }
        } else if currPage == 0 {
            WorkoutView()
        } else if currPage == 1 {
            ExerciseView()
        } else if currPage == 2 {
            MealsView()
        } else if currPage == 4 {
            SettingsView()
        } else if currPage == 5 {
            EventView(events: $events)
        } else if currPage == 6 {
            MeetView()
        } else if currPage == 7 {
            ProfileView()
        } else if currPage == 8 {
            TrainingLogView()
        } else if currPage == 9 {
            InjuryView()
        }
    }
    
    // Load in the current meet dates
    func loadMeets() {
        if let data = UserDefaults.standard.data(forKey: "meetDates") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Date].self, from: data) {
                meets = decoded
            }
        }
        removePastMeets()
    }
    
    // Remove past meet dates
    func removePastMeets() {
        let today = Calendar.current.startOfDay(for: Date())
        meets.removeAll { meet in
            Calendar.current.startOfDay(for: meet) < today
        }
        saveMeets()
    }
    
    // Save the current meet dates
    func saveMeets() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(meets) {
            UserDefaults.standard.set(encoded, forKey: "meetDates")
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
    
    // Removes the notification generated by the meet date
    func removeNotification(for date: Date) {
        let identifier = date.formatted()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
