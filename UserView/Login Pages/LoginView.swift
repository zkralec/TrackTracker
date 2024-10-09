//
//  LoginView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/9/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // Logo
                Image(uiImage: colorScheme == .dark ? UIImage(named: "DarkLogo")! : UIImage(named: "LightLogo")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                // Form fields
                VStack(spacing: 24) {
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
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                // Forgot password?
                
                // Sign in button
                Button {
                    print("Logging user in")
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .frame(width: UIScreen.main.bounds.width - 48, height: 24)
                }
                .buttonStyle(CustomButtonStyle())
                .padding(.top, 24)
                
                
                Spacer()
                
                
                // Sign up
            }
        }
    }
}

#Preview {
    LoginView().preferredColorScheme(.light)
}
