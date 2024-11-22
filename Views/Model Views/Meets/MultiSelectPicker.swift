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
