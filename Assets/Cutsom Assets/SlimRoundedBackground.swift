//
//  SlimRoundedBackground.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 2/14/25.
//

import SwiftUI

struct SlimRoundedBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(Color.gray.opacity(0.08))
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

extension View {
    func slimRoundedBackground() -> some View {
        self.modifier(SlimRoundedBackground())
    }
}
