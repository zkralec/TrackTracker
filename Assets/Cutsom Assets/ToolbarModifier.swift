//
//  ToolbarModifier.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/8/24.
//

import SwiftUI

// Formatting and logic for the custom keyboard dismiss button
struct ToolbarModifier: ViewModifier {
    @Binding var isFocused: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
                .padding(.bottom, isFocused ? 44 : 0)
            
            if isFocused {
                VStack {
                    Spacer()
                    CustomKeyboardToolbar(isFocused: $isFocused)
                }
            }
        }
    }
}
