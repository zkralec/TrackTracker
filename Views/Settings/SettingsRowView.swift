//
//  SettingsRowView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/10/24.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundStyle(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(Color.primary)
        }
    }
}

#Preview {
    SettingsRowView(imageName: "gear", title: "Settings", tintColor: .blue)
}
