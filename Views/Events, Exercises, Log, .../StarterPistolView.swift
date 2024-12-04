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
                        Section {
                            Text("Text field to have user enter how long it takes them to get set and use that as the delay in startersequence.")
                                .foregroundStyle(Color.secondary)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        
                        Section {
                            Text("Want to display words on the screen with a quick fade in and out for each ('On your marks', 'set'). Also want these to go exactly with the timing of the starterSequence.")
                                .foregroundStyle(Color.secondary)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        
                        Section {
                            Button {
                                playStarterSequence(canStart: canStart)
                                canStart = false
                            } label: {
                                Text("Start")
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    
                    Spacer()
                }
                // Show side menu if needed
                SideBar(isSideMenuOpen: $isSideMenuOpen)
            }
        }
    }
    
    private func playStarterSequence(canStart: Bool) {
        // On your mark
        if canStart {
            let mark = AVSpeechUtterance(string: "On your mark")
            mark.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(mark)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                // Set
                let set = AVSpeechUtterance(string: "Set")
                set.voice = AVSpeechSynthesisVoice(language: "en-US")
                self.synthesizer.speak(set)
                
                // Random delay the bang
                let randomDelay = Double.random(in: 1.7...3)
                DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
                    // Play starter gun sound
                    self.starterGunSound?.play()
                }
                
                self.canStart = true
            }
        }
    }
}

#Preview {
    StarterPistolView()
}
