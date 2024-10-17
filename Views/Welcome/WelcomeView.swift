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
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if welcomeScreen {
                VStack {
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
                }
            } else if viewModel.userSession != nil{
                withAnimation {
                    // If user is logged in go to home
                    HomeView()
                }
            } else {
                withAnimation {
                    // If user is not logged in go to login
                    LoginView()
                }
            }
        }
    }
}
