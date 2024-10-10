//
//  SignUpView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/10/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var fName = ""
    @State private var lName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPass = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Logo
            Image(uiImage: colorScheme == .dark ? UIImage(named: "DarkLogo")! : UIImage(named: "LightLogo")!)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.top, -6)
            
            // Form fields
            VStack(spacing: 10) {
                // First name
                LoginInputView(text: $fName,
                               title: "First Name",
                               placeholder: "Enter first name")
                
                // Last name
                LoginInputView(text: $lName,
                               title: "Last Name",
                               placeholder: "Enter last name")
                
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
            
            // Sign in button
            Button {
                print("Sign user up")
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
