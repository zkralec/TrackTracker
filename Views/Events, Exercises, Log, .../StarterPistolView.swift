//
//  StarterPistol.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/30/24.
//

import SwiftUI
import AVFoundation

struct StarterPistolView: View {
    @State private var isSideMenuOpen = false
    @State private var canStart = true
    @State private var started = false
    @State private var displayedText: String = ""
    @State private var seconds = 20
    @State private var userDelay: StarterData?
    @State private var onYourMarksRemainingTime: Double = 20
    @State private var timer: Timer?
    
    private let synthesizer = AVSpeechSynthesizer()
    private var starterGunSound: AVAudioPlayer?
    
    init() {
        // Load starter gun sound
        if let soundURL = Bundle.main.url(forResource: "starter_gun", withExtension: "mp3") {
            starterGunSound = try? AVAudioPlayer(contentsOf: soundURL)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        ZStack {
                            // Display title
                            TitleBackground(title: "Auto Starter")
                            
                            HStack {
                                // Menu bar icon
                                MenuButton(isSideMenuOpen: $isSideMenuOpen)
                                Spacer()
                            }
                        }
                        Divider()
                    }
                    .padding(.bottom, -8)
                    
                    Spacer()
                    
                    List {
                        // Section for user delay changes
                        Section("Mark time") {
                            HStack {
                                Text("Set delay (seconds): ")
                                
                                Spacer()
                                
                                TextField("Time (sec)", text: Binding(
                                    get: { String(seconds) },
                                    set: { newValue in
                                        if validateTimeInput(newValue) {
                                            seconds = Int(newValue) ?? 20
                                            userDelay = StarterData(delay: seconds)
                                        }
                                    }
                                ))
                                .multilineTextAlignment(.trailing)
                                .onChange(of: seconds) {
                                    saveDelay()
                                }
                            }
                        }
                        
                        // Will display text when started
                        if started {
                            withAnimation {
                                Section {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            
                                            if displayedText == "On your marks" {
                                                CountdownRing(
                                                    totalTime: Double(seconds),
                                                    remainingTime: onYourMarksRemainingTime,
                                                    lineWidth: 10,
                                                    ringColor: .blue
                                                )
                                                .padding()
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                        Text(displayedText)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .padding()
                                    }
                                }
                            }
                        }
                    }
                    .listSectionSpacing(15)
                    
                    Spacer()
                    
                    VStack {
                        Divider()
                            .padding(.top, -8)
                        
                        // Button to start
                        Button(action: {
                            playStarterSequence(canStart: canStart, seconds: seconds)
                            canStart = false
                            started = true
                        }) {
                            HStack {
                                Image(systemName: "play.circle")
                                Text("Start")
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(10)
                    }
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
        .onAppear {
            loadDelay()
        }
        .onDisappear {
            saveDelay()
        }
    }
    
    // This plays all the sounds and text that is needed based on user input
    private func playStarterSequence(canStart: Bool, seconds: Int) {
        if canStart {
            onYourMarksRemainingTime = Double(seconds)
            startCountdownTimer()
            
            // On your mark
            let mark = AVSpeechUtterance(string: "On your marks")
            mark.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(mark)
            displayedText = "On your marks"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(seconds)) {
                stopCountdownTimer()
                
                // Set
                let randomDelay = Double.random(in: 1...2.5)
                DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
                    let set = AVSpeechUtterance(string: "Set")
                    set.voice = AVSpeechSynthesisVoice(language: "en-US")
                    synthesizer.speak(set)
                    displayedText = "Set"
                    
                    // Bang
                    let randomDelay = Double.random(in: 1.5...2.5)
                    DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
                        self.starterGunSound?.play()
                        displayedText = "GO"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            self.canStart = true
                            self.started = false
                        }
                    }
                }
            }
        }
    }
    
    // Function to validate the input for time
    func validateTimeInput(_ input: String) -> Bool {
        return (input.isEmpty || Int(input) != nil) && input.count <= 2
    }
    
    // Load the user delay from UserDefaults
    private func loadDelay() {
        if let data = UserDefaults.standard.data(forKey: "delay"),
           let decoded = try? JSONDecoder().decode(StarterData.self, from: data) {
            userDelay = decoded
            seconds = userDelay?.delay ?? 20
        }
    }
    
    // Save the user delay to UserDefaults
    private func saveDelay() {
        userDelay = StarterData(delay: seconds)
        if let encoded = try? JSONEncoder().encode(userDelay) {
            UserDefaults.standard.set(encoded, forKey: "delay")
        }
    }
    
    private func startCountdownTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if onYourMarksRemainingTime > 0 {
                onYourMarksRemainingTime -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
    
    private func stopCountdownTimer() {
        timer?.invalidate()
    }
    
    struct CountdownRing: View {
        let totalTime: Double
        let remainingTime: Double
        let lineWidth: CGFloat
        let ringColor: Color

        var body: some View {
            ZStack {
                Circle()
                    .stroke(lineWidth: lineWidth)
                    .opacity(0.3)
                    .foregroundColor(ringColor)

                Circle()
                    .trim(from: 0.0, to: CGFloat(remainingTime / totalTime))
                    .stroke(ringColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.1), value: remainingTime)

                Text("\(Int(remainingTime))")
                    .font(.system(size: lineWidth * 2, weight: .bold))
                    .foregroundColor(ringColor)
            }
            .padding(lineWidth / 2)
        }
    }
}

#Preview {
    StarterPistolView()
}
