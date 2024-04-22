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
    @State private var currPage: Int = 6

    var body: some View {
        if currPage == 6 {
            VStack {
                // Title
                TitleBackground(title: "Select Meet Days")
                
                List {
                    Section {
                        VStack {
                            // Calendar
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                            
                            // Add meet date button
                            HStack {
                                Spacer()
                                
                                Button("Add Meet") {
                                    meets.append(date)
                                    scheduleNotification(for: date)
                                    saveMeets()
                                    print("Added meet \(date)")
                                }
                                .buttonStyle(CustomButtonStyle())
                                .padding()
                                
                                Spacer()
                            }
                        }
                    }
                    .listSectionSpacing(15)
                    
                    // Remove and display meet dates
                    Section {
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text("Meet Days")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .padding()
                                
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
                                    
                                    // Remove the last meet day
                                    Button("Remove Last") {
                                        removeMeet(at: meets.count - 1)
                                        print("Removed last meet")
                                    }
                                    .buttonStyle(CustomButtonStyle())
                                    .padding()
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .listSectionSpacing(15)
                }
                .background(Color.gray.opacity(0.05))
                
                Button("Save") {
                    withAnimation {
                        currPage = 4
                    }
                }
                .buttonStyle(CustomButtonStyle())
                .frame(width: 120, height: 40)
                .padding()
            }
            .onAppear {
                loadMeets()
            }
        } else if currPage == 4 {
            SettingsView()
        }
    }

    // Makes a notification that will go off at the correct date
    func scheduleNotification(for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Good luck with your meet!"
        content.body = "You have a meet scheduled for \(date.formatted())"
        content.sound = UNNotificationSound.default

        var triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: date)
        triggerDate.hour = 6
        triggerDate.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

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

    // Removes the notification generates by the last meet date
    func removeNotification(for date: Date) {
        let identifier = "\(date)"
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

#Preview {
    MeetView()
}
