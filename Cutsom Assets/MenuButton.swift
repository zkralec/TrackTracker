//
//  MenuBar.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/25/24.
//

import SwiftUI

// This button brings up the side bar for more navigation
struct MenuButton: View {
    @Binding var isSideMenuOpen: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    isSideMenuOpen.toggle()
                }
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 25))
                    .foregroundStyle(.blue)
            }
            .frame(width: 70, height: 30)
            .buttonStyle(ButtonPress())
            .padding(.bottom,-10)
            
            Spacer()
        }
    }
}
