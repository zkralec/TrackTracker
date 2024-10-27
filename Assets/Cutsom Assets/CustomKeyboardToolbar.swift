//
//  CustomKeyboardToolbar.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/27/24.
//

import SwiftUI

// Overall works for having a button to dismiss keyboard
import SwiftUI

struct CustomKeyboardToolbar: View {
    @Binding var isFocused: Bool

    var body: some View {
        HStack {
            Spacer()
            Button("Done") {
                // Dismiss keyboard and update focus
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                isFocused = false
            }
            .padding(.trailing)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(Color(UIColor.systemGray5))
    }
}
