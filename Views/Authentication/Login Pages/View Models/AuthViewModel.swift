//
//  AuthViewModel.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/14/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    // If there is a current user, do not sign in
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    // Signs in the user if they decided to sign out
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    // Creates a user when the user enters valid profile info
    func createUser(team: String, withEmail email: String, password: String, fullName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, team: team, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    // Signs out the user
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // Deletes the user account
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
                throw URLError(.badURL)
            }
            do {
                try await Firestore.firestore().collection("users").document(user.uid).delete()
                print("DEBUG: Successfully deleted user document for userID: \(user.uid)")
            } catch {
                print("DEBUG: Error deleting Firestore documents: \(error.localizedDescription)")
                throw error
            }
            do {
                try await user.delete()
                self.userSession = nil
                self.currentUser = nil
            } catch {
                print("DEBUG: Error deleting user: \(error.localizedDescription)")
                throw error
            }
    }
    
    // Will fetch user details for loading
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func resetPassword(withEmail email: String) async {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("DEBUG: Failed to send password reset with error \(error.localizedDescription)")
        }
    }
}
