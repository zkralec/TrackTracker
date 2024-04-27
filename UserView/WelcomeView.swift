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

    var body: some View {
        VStack {
            if welcomeScreen {
                // Welcome message
                Text("Track Tracker")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                
                // App logo
                Image(uiImage: #imageLiteral(resourceName: "TrackTrackerLogo"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .onAppear {
                        // Removes welcome screen after 3 seconds
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
