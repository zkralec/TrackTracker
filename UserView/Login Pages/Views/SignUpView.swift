//
//  SignUpView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/10/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPass = ""
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            // Logo
            Image(uiImage: colorScheme == .dark ? UIImage(named: "DarkLogo")! : UIImage(named: "LightLogo")!)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
            // Form fields
            VStack(spacing: 10) {
                // First name
                LoginInputView(text: $fullName,
                               title: "Full Name",
                               placeholder: "Enter full name")
                
                // Username
                LoginInputView(text: $email,
                               title: "Email Address",
                               placeholder: "name@example.com")
                .autocapitalization(.none)
                
                // Password
                LoginInputView(text: $password,
                               title: "Password",
                               placeholder: "Enter your password",
                               isSecureField: true)
                .autocapitalization(.none)
                
                // Confirm password
                LoginInputView(text: $confirmPass,
                               title: "Confirm Password",
                               placeholder: "Confirm your password",
                               isSecureField: true)
                .autocapitalization(.none)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            
            // Sign up button
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email, password: password, fullName: fullName)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .frame(width: UIScreen.main.bounds.width - 56, height: 24)
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.top, 10)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                NavigationLink {
                    LoginView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(Color.blue)
                    .font(.system(size: 14))
                }
            }
        }
    }
}

#Preview {
    SignUpView().preferredColorScheme(.light)
}