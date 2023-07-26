//
//  AuthManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/01.
//

import Foundation
import Factory
import Combine
import AuthenticationServices

import FirebaseAuth
import FirebaseFirestore


enum AuthState {
    case unAuthenticated, authenticated
}

public enum NickNameRegisteredState {
    case newUser, registering, existingUser
}

@MainActor
final class AuthManager: ObservableObject {
    struct NickName {
        var name: String
        var isValidate: Bool {
            name.count <= 8 && !name.isEmpty
        }
    }
    
    @Injected(\.authService) private var authService
    @Injected(\.firestore) private var database
    @Published var currentUser: User?
    @Published var authState: AuthState = .unAuthenticated
    @Published var nickNameRegisterState: NickNameRegisteredState = .existingUser
    @Published var nickName: NickName = NickName(name: "")
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        authService
            .$user
            .assign(to: &$currentUser)
        
        authService
            .$nickNameRegisteredState
            .assign(to: &$nickNameRegisterState)
        
        $currentUser
            .map { user in
                if user != nil {
                    return AuthState.authenticated
                }
                return AuthState.unAuthenticated
            }
            .assign(to: &$authState)
       
    }
    
    func requestAppleSignUp(request: ASAuthorizationAppleIDRequest) {
        authService.requestAppleSignUp(request: request)
    }
    
    func completeAppleSignUp(result: Result<ASAuthorization, Error>) {
        authService.completeAppleSignUp(result: result)
    }
    
    func signOut() {
        authService.signOut()
    }

}

// MARK: - NickNameLogic
extension AuthManager {
    func registerMemberNickName() {
        guard let uid = currentUser?.uid else { return }
        guard nickName.isValidate else { return }
        let userReference = database.collection("Members").document(uid)
        userReference.setData(["nickName" : nickName.name], merge: true)
        forcedLoading()
    }
    
    func forcedLoading() {
        nickNameRegisterState = .registering
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.nickNameRegisterState = .existingUser
        }
    }

    func resetNickName() {
        nickName.name.removeAll()
    }
}
