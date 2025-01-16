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
        Text(title)
            .foregroundStyle(.black)
            .font(.title)
            .fontWeight(.bold)
    }
}
