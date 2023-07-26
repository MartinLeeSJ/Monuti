//
//  AuthService.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/26.
//

import Foundation
import AuthenticationServices
import CryptoKit
import Factory

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

public class AuthService {
    @Injected(\.firestore) private var database
    @Injected(\.auth) private var auth
    @Published var user: User?
    @Published var nickNameRegisteredState: NickNameRegisteredState = .existingUser
    @Published var errorMessage = ""
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?
    
    init() {
        registerAuthStateHandler()
    }
    
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = auth.addStateDidChangeListener { auth, user in
                self.user = user
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        }
        catch {
            print("Error while trying to sign out: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            signOut()
            return true
        }
        catch {
            print(error.localizedDescription)
            return false
        }
    }
}


extension AuthService {
    func requestAppleSignUp(request: ASAuthorizationAppleIDRequest) -> Void {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }
    
    func completeAppleSignUp(result: Result<ASAuthorization, Error>) -> Void {
        switch result {
        case .success(let authResults):
            guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential,
                  let nonce = currentNonce else {
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                return
            }
            
            let authCredential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                                 rawNonce: nonce,
                                                                 fullName: appleIDCredential.fullName)
            
            signInFirebase(with: authCredential)
           
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    
    private func signInFirebase(with authCredential: OAuthCredential) -> Void {
        Task {
            do {
                let authResult = try await auth.signIn(with: authCredential)
                let userReference = database.collection("Members").document(authResult.user.uid)
                let documentSnapshot = try await userReference.getDocument()
                
                guard !documentSnapshot.exists else {
                    return
                }
                
                try await userReference.setData(["email" : authResult.user.email ?? "",
                                               "createdAt" : Timestamp(date: Date.now)])
                nickNameRegisteredState = .newUser
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
   

    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.reduce("", { x,y in x + y })
        
        return hashString
    }
}
