//
//  CustomCircleButtonStyle.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/8/24.
//

import SwiftUI

struct CustomCircleButtonStyle: ButtonStyle {
    var buttonColor: Color = .blue
    var buttonSize: CGFloat = 50

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.title)
            .padding()
            .background(
                Circle()
                    .fill(buttonColor)
                    .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            )
            .frame(width: buttonSize, height: buttonSize)
            .shadow(radius: configuration.isPressed ? 3 : 5)
    }
}
