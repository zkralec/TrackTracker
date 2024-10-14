//
//  ButtonPress.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/8/24.
//

import SwiftUI

// Gives button clicks a satisfying enimaiton
struct ButtonPress: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
