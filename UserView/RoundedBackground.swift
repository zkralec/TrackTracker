//
//  RoundedGreyBackground.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/11/24.
//

import SwiftUI

// Makes a custom background for text
struct RoundedBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
    }
}

extension View {
    func roundedBackground() -> some View {
        self.modifier(RoundedBackground())
    }
}
