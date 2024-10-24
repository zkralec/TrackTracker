//
//  MeetCalendarView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import SwiftUI
import UserNotifications

// Allows user to choose meet dates and display them
struct MeetView: View {
    @State private var date = Date()
    @State private var meets: [Date] = []
    @State private var isSideMenuOpen = false
    
    @State private var events: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack {
                        // Display title
                        TitleBackground(title: "Meets")
                        
                        HStack {
                            // Menu bar icon
                            MenuButton(isSideMenuOpen: $isSideMenuOpen)
                            Spacer()
                        }
                    }
                    
                    List {
                        // Remove and display meet dates
                        Section("Meets") {
                            HStack {
                                Spacer()
                                
                                VStack {
                                    if meets.isEmpty {
                                        Text("No meet days selected")
                                            .foregroundStyle(.secondary)
                                            .padding()
                                    } else {
                                        VStack {
                                            ForEach(meets, id: \.self) { date in
                                                Text(date.formatted())
                                                    .padding(5)
                                                    .roundedBackground()
                                            }
                                            
                                            // Remove the last meet day
                                            Button(action: {
                                                withAnimation {
                                                    removeMeet(at: meets.count - 1)
                                                    print("Removed last meet")
                                                }
                                            }) {
                                                HStack {
                                                    Image(systemName: "minus")
                                                        .foregroundStyle(.white)
                                                        .frame(width: 30, height: 30)
                                                    Text("Remove Last")
                                                        .font(.subheadline)
                                                        .foregroundStyle(.white)
                                                        .padding(4)
                                                }
                                                .padding(-8)
                                            }
                                            .buttonStyle(CustomButtonStyle())
                                        }
                                        .padding()
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        .listSectionSpacing(15)
                        
                        // Allows user to set their meet days
                        Section("Add Meet Days") {
                            VStack {
                                // Calendar
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                
                                // Add meet date button
                                Button(action: {
                                    withAnimation {
                                        meets.append(date)
                                        scheduleNotification(for: date)
                                        saveMeets()
                                        print("Added meet \(date)")
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "plus")
                                            .foregroundStyle(.white)
                                            .frame(width: 30, height: 30)
                                        Text("Add Meet")
                                            .font(.subheadline)
                                            .foregroundStyle(.white)
                                            .padding(4)
                                    }
                                    .padding(-8)
                                }
                                .buttonStyle(CustomButtonStyle())
                            }
                            .padding()
                        }
                        .listSectionSpacing(15)
                    }
                }
                .onAppear {
                    loadMeets()
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
    
    // Makes a notification that will go off at the correct date
    func scheduleNotification(for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "You have a meet today!"
        content.body = "Make sure to run fast, jump high, and throw far. Push yourself!"
        content.sound = UNNotificationSound.default
        
        var triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: date)
        triggerDate.hour = 1
        triggerDate.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: date.formatted(), content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for \(date.formatted())")
            }
        }
    }
    
    // Save the current meet dates
    func saveMeets() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(meets) {
            UserDefaults.standard.set(encoded, forKey: "meetDates")
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
    }
    
    // Removes the last meet
    func removeMeet(at index: Int) {
        if index >= 0 && index < meets.count {
            let removedDate = meets.remove(at: index)
            removeNotification(for: removedDate)
            saveMeets()
        }
    }
    
    // Removes the notification generated by the last meet date
    func removeNotification(for date: Date) {
        let identifier = date.formatted()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

// Used for formatting the date
extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
