//
//  MenuBar.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/25/24.
//

import SwiftUI

struct MenuBar: View {
    @Binding var isSideMenuOpen: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    isSideMenuOpen.toggle()
                }
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20))
                    .foregroundStyle(.blue)
            }
            .frame(width: 70, height: 30)
            .buttonStyle(ButtonPress())
            
            Spacer()
        }
    }
}
