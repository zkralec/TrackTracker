//
//  AuthViewModel.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/14/24.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign in")
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        print("Create user")
    }
    
    func signOut() {
        
    }
    
    func deleteAccount() {
        
    }
    
    func fetchLoginDetails() {
        
    }
}
