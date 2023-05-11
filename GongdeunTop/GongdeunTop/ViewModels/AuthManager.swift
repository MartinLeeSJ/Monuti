//
//  AuthManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/01.
//

import Foundation
import AuthenticationServices
import CryptoKit

import FirebaseAuth
import FirebaseFirestore




final class AuthManager: ObservableObject {
    enum AuthState {
        case unAuthenticated, authenticated, authenticating
    }
    
    @Published var authState: AuthState = .authenticating
    @Published var currentUser: User?
    
    private let database = Firestore.firestore()
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    var currentNonce: String?
    
    init() {
        registerAuthStateHandler()
    }
    
    private func registerAuthStateHandler() {
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
                self.currentUser = user
                self.authState =  user == nil ? .unAuthenticated : .authenticated
            }
        }
    }
    
    
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
            
            let authCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            
            signInFirebase(with: authCredential)
           
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func signInFirebase(with authCredential: OAuthCredential) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(with: authCredential)
                let userReference = database.collection("Members").document(authResult.user.uid)
                let documentSnapshot = try await userReference.getDocument()
                
                guard !documentSnapshot.exists else {
                    print("User is already exists and signed in")
                    return
                }
                
                let memberData = Member(email: authResult.user.email ?? "", createdAt: Timestamp(date: Date.now))
                
                try userReference.setData(from: memberData)
                
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
    
    
    public func signOut() {
        try? Auth.auth().signOut()
    }
}
