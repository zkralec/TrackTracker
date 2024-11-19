//
//  MeetCalendarView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import SwiftUI
import UserNotifications

// Allows user to choose meet dates and display them
struct MeetEditView: View {
    @State private var date = Date()
    @State private var meets: [Date] = []
    @State private var isSideMenuOpen = false
    @State private var meetDate: Date = Date()
    @State private var meetLocation: String = "SMCM"
    @State private var indoorOutdoor: String = "Outdoor"
    @State private var events: [String] = ["100 meter", "Pole Vault"]
    @ObservedObject var settings = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var events2: [EventData] = {
        if let savedEvents = UserDefaults.standard.array(forKey: "selectedEvents") as? [String] {
            return savedEvents.compactMap { EventData(rawValue: $0) }
        } else {
            return []
        }
    }()
    
    @Binding var meetLog: [MeetData]
    var meet: MeetData
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TitleBackground(title: "Meet Scheduling")
                        .padding(.top, 28)
                    
                    List {
                        // Allows user to set their meet days
                        Section("Add Meet Days") {
                            VStack {
                                // Calendar
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                            }
                            .padding()
                        }
                        
                        // Confirm button
                        Section {
                            Button(action: {
                                meets.append(date)
                                scheduleNotification(for: date)
                                saveMeets()
                                addMeet()
                                saveMeetLog()
                                // Feature to enable or disable haptics
                                if settings.isHapticsEnabled {
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
                                }
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Confirm")
                                    .font(.system(size: 20))
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(CustomButtonStyle())
                        }
                    }
                    .listSectionSpacing(10)
                }
                .onAppear {
                    loadMeets()
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
    
    // Reset to default values
    private func resetFields() {
        meetDate = Date()
        meetLocation = "St. Mary's College of Maryland"
        indoorOutdoor = "Indoor"
        events = []
    }
    
    // Add or update in injury log
    private func addMeet() {
        let newMeet = MeetData(
            meetDate: meetDate,
            meetLocation: meetLocation,
            indoorOutdoor: indoorOutdoor,
            events: events
        )

        meetLog.append(newMeet)
    }
    
    // Save the injury
    private func saveMeetLog() {
        if let encoded = try? JSONEncoder().encode(meetLog) {
            UserDefaults.standard.set(encoded, forKey: "meetLog")
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
