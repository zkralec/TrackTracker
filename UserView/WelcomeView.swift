//
//  WelcomeView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/20/24.
//

import SwiftUI

// Welcomes users when opening app
struct WelcomeView: View {
    @State private var welcomeScreen = true
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            if welcomeScreen {
                // Welcome message
                Text("Track Tracker")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                // App logo
                Image(uiImage: colorScheme == .dark ? UIImage(named: "DarkLogo")! : UIImage(named: "LightLogo")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .onAppear {
                        // Removes welcome screen after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                // Hide the welcome screen
                                welcomeScreen = false
                            }
                        }
                    }
            } else {
                // Go to LoginView after welcome
                LoginView()
            }
        }
    }
}
