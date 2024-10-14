//
//  LoginInputView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/9/24.
//

import SwiftUI

struct LoginInputView: View {
    @Binding var text: String
    
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundStyle(Color.primary)
                .fontWeight(.semibold)
                .font(.footnote)
            
            VStack {
                if isSecureField {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 14))
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 14))
                }
            }
            .frame(height: 32)
            .roundedBackground()
            
            Divider()
        }
    }
}

#Preview {
    LoginInputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
