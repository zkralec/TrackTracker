//
//  StarterPistol.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/30/24.
//

import SwiftUI
import AVFoundation

struct StarterPistolView: View {
    let voice = AVSpeechSynthesisVoice(language: "English")
    let mark = AVSpeechUtterance(string: "On your mark")
    let set = AVSpeechUtterance(string: "Set")
    
    @State private var isSideMenuOpen = false
    
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
                            Text("This will be a button which will play a randomly timed, automatic starter pistol sound so the user does not have to start themselves. It will say: 'On your mark, set, BANG'. It will be timed randomly so it is different every time for the user. ")
                                .foregroundStyle(Color.secondary)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        
                        Section {
                            Button {
                                mark.voice = voice
                                set.voice = voice
                                
                                AVSpeechSynthesizer().speak(mark)
                                sleep(UInt32(Int.random(in: 1...5)))
                                AVSpeechSynthesizer().speak(set)
                            } label: {
                                Text("Start")
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
}

#Preview {
    StarterPistolView()
}
