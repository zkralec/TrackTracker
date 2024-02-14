//
//  ContentView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/20/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userDataManager = UserDataManager()
    @State private var showWelcomeScreen = true
    
    var body: some View {
        ZStack {
            if showWelcomeScreen {
                WelcomeView()
                    .opacity(showWelcomeScreen ? 1 : 0)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeInOut(duration: 1)) {
                                showWelcomeScreen = false
                            }
                        }
                    }
            } else {
                    MealsView(userDataManager: userDataManager)
                StretchesView(userDataManager: userDataManager)
                HomePageView(userDataManager: userDataManager)
            }
        }
    }
}

#Preview {
    ContentView()
}
