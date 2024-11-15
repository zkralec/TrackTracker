//
//  WorkoutTogglesView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/17/24.
//

import SwiftUI

struct WorkoutTogglesView: View {
    let sectionTitle: String
    let toggles: [(String, Binding<Bool>)]
    let isDisabled: Bool
    
    var body: some View {
        Section {
            DisclosureGroup(sectionTitle) {
                VStack(spacing: 15) {
                    ForEach(toggles, id: \.0) { label, binding in
                        Toggle(label, isOn: binding)
                            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                            .font(.subheadline)
                            .disabled(!binding.wrappedValue && anyTogglesOn(toggles))
                            .padding(.trailing)
                    }
                }
            }
        }
        .listSectionSpacing(10)
    }

    private func anyTogglesOn(_ toggles: [(String, Binding<Bool>)]) -> Bool {
        toggles.contains { $0.1.wrappedValue }
    }
}

#Preview {
    @Previewable @State var isOff = false
    return WorkoutTogglesView (
        sectionTitle: "Test Toggles", toggles: [("Off day", $isOff)], isDisabled: false
    )
}
