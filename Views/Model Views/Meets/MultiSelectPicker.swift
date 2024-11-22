//
//  MultiSelectPicker.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 11/20/24.
//

import SwiftUI

struct MultiSelectPicker: View {
    @State var allItems: [String]
    
    @Binding var selectedItems: [String]
    
    var body: some View {
        Form {
            List {
                ForEach(allItems, id: \.self) { item in
                    Button {
                        withAnimation {
                            if self.selectedItems.contains(item) {
                                self.selectedItems.removeAll(where: { $0 == item })
                            } else {
                                self.selectedItems.append(item)
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "checkmark")
                                .opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
                            Text(item)
                        }
                    }
                    .foregroundStyle(Color.primary)
                }
             }
        }
    }
}

struct PickingView: View {
    @State var selectedItems: [String]
    @State var allItems: [String]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Choose events:", content: {
                    NavigationLink(destination: {
                        MultiSelectPicker(allItems: allItems, selectedItems: $selectedItems)
                            .navigationTitle("Choose Your Events")
                    }, label: {
                        HStack {
                            Text("Select events:")
                                .foregroundStyle(Color.blue)
                            Spacer()
                            Image(systemName: "\($selectedItems.count).circle")
                                .foregroundStyle(Color.blue)
                                .font(.title2)
                        }
                    })
                })
                
                Section("Your events are:", content: {
                    Text(selectedItems.joined(separator: "\n"))
                        .foregroundStyle(Color.secondary)
                })
            }
            .navigationTitle("My Events")
        }
    }
}
