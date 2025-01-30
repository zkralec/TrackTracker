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
            .padding()
            .background(Color.gray.opacity(0.08))
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
            .padding(.vertical, 10)
    }
}

extension View {
    func roundedBackground() -> some View {
        self.modifier(RoundedBackground())
    }
}
