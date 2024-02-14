//
//  TitleBackground.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/17/24.
//

import SwiftUI

// Makes a custom title style
struct TitleBackground: View {
    var title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.blue)
                .frame(height: 40)
                .padding(.horizontal, 20)
            
            Text(title)
                .foregroundStyle(.white)
                .font(.title)
                .fontWeight(.bold)
        }
        .padding(.vertical, 10)
    }
}
