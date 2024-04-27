//
//  SideBar.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 4/26/24.
//

import SwiftUI

struct SideBar: View {
    @Binding var currPage: Int
    @Binding var isSideMenuOpen: Bool
    
    var body: some View {
        VStack {
            Divider()
            VStack(alignment: .leading) {
                // Menu items
                Button(action: {
                    withAnimation {
                        currPage = 5
                        isSideMenuOpen.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "figure.track.and.field")
                            .foregroundStyle(.blue)
                        Text("Events")
                            .padding(.vertical)
                    }
                    .fontWeight(.medium)
                    .font(.system(size: 20))
                }
                .transition(.move(edge: .leading))
                .padding(6)
                Button(action: {
                    withAnimation {
                        currPage = 6
                        isSideMenuOpen.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(.blue)
                        Text("Meets")
                            .padding(.vertical)
                    }
                    .fontWeight(.medium)
                    .font(.system(size: 20))
                }
                .padding(6)
                Button(action: {
                    withAnimation {
                        currPage = 4
                        isSideMenuOpen.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "gearshape")
                            .foregroundStyle(.blue)
                        Text("Settings")
                            .padding(.vertical)
                    }
                    .fontWeight(.medium)
                    .font(.system(size: 20))
                }
                .padding(6)
            }
        }
        .transition(.move(edge: .leading))
        .padding(.top,-8)
    }
}
