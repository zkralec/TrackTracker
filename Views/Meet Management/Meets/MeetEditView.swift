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
    @State private var meetLocation: String = ""
    @State private var indoorOutdoor: String = "Outdoor"
    @State private var events: [String] = []
    @ObservedObject var settings = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Binding var meetLog: [MeetData]
    var meet: MeetData
    
    let indoorOutdoorTypes = ["Outdoor", "Indoor"]
    
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
                        
                        Section {
                            HStack {
                                Text("Location")
                                
                                Spacer()
                                
                                TextField("School Location", text: $meetLocation) {
                                    
                                }
                                .multilineTextAlignment(.trailing)
                            }
                        }
                        
                        Section {
                            Picker("Facility Type", selection: $indoorOutdoor) {
                                ForEach(indoorOutdoorTypes, id: \.self) { group in
                                    Text(group).tag(group)
                                        .foregroundStyle(Color.blue)
                                }
                            }
                        }
                        
                        Section {
                            HStack {
                                Text("Events")
                                
                                Spacer()
                                
                                Picker("", selection: $events) {
                                    ForEach(EventData.allCases, id: \.self) { event in
                                        Text("\(event.rawValue)")
                                    }
                                }
                            }
                        }
 
                        // Confirm button
                        Section {
                            Button(action: {
                                scheduleNotification(for: date)
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
