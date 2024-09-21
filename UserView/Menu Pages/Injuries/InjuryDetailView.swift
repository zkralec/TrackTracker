//
//  InjuryDetailView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 9/20/24.
//

import SwiftUI

struct InjuryDetailView: View {
    @State private var currPage: Int = 10
    @State private var isSideMenuOpen = false
    
    var body: some View {
        if currPage == 10 {
            ZStack {
                VStack {
                    TitleBackground(title: "Add New Injury")
                        .padding(.top, 28)
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                currPage = 9
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.blue)
                                .font(.system(size: 25))
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(ButtonPress())
                        .padding(.top)
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    
                    List {
                        Text("Placeholder")
                    }
                }
            }
        } else if currPage == 9 {
            InjuryView()
        }
    }
}
