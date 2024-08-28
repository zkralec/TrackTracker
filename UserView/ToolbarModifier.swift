//
//  ToolbarModifier.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/8/24.
//

import SwiftUI

// Adds a done button to exit a text popup
struct ToolbarModifier: ViewModifier {
    @Binding var isFocused: Bool

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    if isFocused {
                        HStack {
                            Spacer()
                            Button("Done") {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                isFocused = false
                            }
                            .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
            }
    }
}
