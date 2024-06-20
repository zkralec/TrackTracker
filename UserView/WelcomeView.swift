//
//  WelcomeView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/20/24.
//

import SwiftUI

// Welcomes users when opening app
struct WelcomeView: View {
    @State private var welcomeScreen = true // Shows welcome view or not
    @Environment(\.colorScheme) var colorScheme // Access the current color scheme

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
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .onAppear {
                        // Removes welcome screen after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                welcomeScreen = false // Hide the welcome screen
                            }
                        }
                    }
            } else {
                // Go to UserInputView after welcome
                UserInputView()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
