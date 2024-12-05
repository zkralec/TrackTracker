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
    @State private var seconds = 10
    @State private var userDelay: StarterData?
    
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
                        Section("Mark time") {
                            HStack {
                                Text("Set delay (seconds): ")
                                
                                Spacer()
                                
                                TextField("Time (sec)", text: Binding(
                                    get: { String(seconds) },
                                    set: { newValue in
                                        if validateTimeInput(newValue) {
                                            seconds = Int(newValue) ?? 10
                                        }
                                    }
                                ))
                                .multilineTextAlignment(.trailing)
                            }
                        }
                        
                        // Possibly have sheet be presented to show "On your mark", "Set", "Go"
                        if started {
                            withAnimation {
                                Section {
                                    HStack {
                                        Spacer()
                                        
                                        Text(displayedText)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .animation(.easeInOut(duration: 0.5))
                                            .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height)/2)
                                        
                                        Spacer()
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
                        
                        // Button to add a new meet
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
    
    private func playStarterSequence(canStart: Bool, seconds: Int) {
        // On your mark
        if canStart {
            let mark = AVSpeechUtterance(string: "On your marks")
            mark.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(mark)
            displayedText = "On your marks"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(seconds)) {
                // Set
                let set = AVSpeechUtterance(string: "Set")
                set.voice = AVSpeechSynthesisVoice(language: "en-US")
                self.synthesizer.speak(set)
                displayedText = "Set"
                
                // Random delay the bang
                let randomDelay = Double.random(in: 1.9...3.1)
                DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
                    // Play starter gun sound
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
    
    // Function to validate the input for time
    func validateTimeInput(_ input: String) -> Bool {
        return (input.isEmpty || Int(input) != nil) && input.count <= 2
    }
    
    // Load the user delay from UserDefaults
    private func loadDelay() {
        if let data = UserDefaults.standard.data(forKey: "delay"),
           let decoded = try? JSONDecoder().decode(StarterData.self, from: data) {
            userDelay = decoded
        }
    }
    
    // Save the user delay to UserDefaults
    private func saveDelay() {
        if let encoded = try? JSONEncoder().encode(userDelay) {
            UserDefaults.standard.set(encoded, forKey: "delay")
        }
    }
}

#Preview {
    StarterPistolView()
}
