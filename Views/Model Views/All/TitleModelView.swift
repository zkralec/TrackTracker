//
//  TitleModelView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 1/15/25.
//

import SwiftUI

struct TitleModelView: View {
    @State var title: String
    @State var menu: Bool
    @Binding var isSideMenuOpen: Bool
    
    var body: some View {
        VStack {
            ZStack {
                // Display title
                TitleBackground(title: "\(title)")
                
                if menu {
                    HStack {
                        // Menu bar icon
                        MenuButton(isSideMenuOpen: $isSideMenuOpen)
                        Spacer()
                    }
                }
            }
            Divider()
        }
        .padding(.bottom, -8)
    }
}
