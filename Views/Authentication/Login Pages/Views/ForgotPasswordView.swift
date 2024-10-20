//
//  ForgotPasswordView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/9/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var email = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            // Logo
            Image(uiImage: colorScheme == .dark ? UIImage(named: "DarkLogo")! : UIImage(named: "LightLogo")!)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
            VStack(spacing: 24) {
                // Username
                LoginInputView(text: $email,
                               title: "Email Address",
                               placeholder: "Enter the email associated with your account")
                .autocapitalization(.none)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            
            // Send email request
            Button {
                Task {
                    await viewModel.resetPassword(withEmail: email)
                }
            } label: {
                HStack {
                    Text("SEND RESET LINK")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .frame(width: UIScreen.main.bounds.width - 56, height: 24)
            }
            .buttonStyle(CustomButtonStyle())
            .disabled(!formValid)
            .opacity(formValid ? 1.0 : 0.5)
            .padding(.top, 10)
            
            Spacer()
        }
    }
}

// Form validation to make sure email is typed in
extension ForgotPasswordView: AuthenticationFormProtocol {
    var formValid: Bool {
        return !email.isEmpty
        && email.contains("@")
    }
}

#Preview {
    ForgotPasswordView()
}
