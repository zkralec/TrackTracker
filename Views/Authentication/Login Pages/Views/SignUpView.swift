//
//  SignUpView.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/10/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var team = ""
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
            VStack(spacing: 12) {
                // Team name (if applicable)
                LoginInputView(text: $team,
                               title: "Track Team",
                               placeholder: "Enter team name (if applicable)")
                
                // First name
                LoginInputView(text: $fullName,
                               title: "Full Name",
                               placeholder: "Enter full name (ex. John Smith)")
                
                // Username
                LoginInputView(text: $email,
                               title: "Email Address",
                               placeholder: "name@example.com")
                .autocapitalization(.none)
                
                // Password
                VStack {
                    LoginInputView(text: $password,
                                   title: "Password",
                                   placeholder: "Enter your password",
                                   isSecureField: true)
                    .autocapitalization(.none)
                    
                    Text("8+ characters, one number, uppercase, and special character")
                        .foregroundStyle(Color.secondary)
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .padding(.bottom, 5)
                }
                
                // Confirm password
                ZStack(alignment: .trailing) {
                    LoginInputView(text: $confirmPass,
                                   title: "Confirm Password",
                                   placeholder: "Confirm your password",
                                   isSecureField: true)
                    .autocapitalization(.none)
                    
                    if !password.isEmpty && !confirmPass.isEmpty {
                        if password == confirmPass {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.green)
                                .padding(.top, 15)
                                .padding(.trailing, 5)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.red)
                                .padding(.top, 15)
                                .padding(.trailing, 5)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            
            // Sign up button
            Button {
                Task {
                    try await viewModel.createUser(team: team, withEmail: email, password: password, fullName: fullName)
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
            .disabled(!formValid)
            .opacity(formValid ? 1.0 : 0.5)
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

// Form validation to make sure fields have valid info
extension SignUpView: AuthenticationFormProtocol {
    var formValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 7
        && password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|:\"';<>,.?/~`")) != nil
        && password.contains { $0.isNumber }
        && password.contains { $0.isUppercase }
        && !fullName.isEmpty
        && fullName != " "
        && fullName.contains(" ")
        && confirmPass == password
    }
}

#Preview {
    SignUpView().preferredColorScheme(.light)
}
