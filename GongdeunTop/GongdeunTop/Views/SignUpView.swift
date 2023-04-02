//
//  SignUpView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/01.
//

import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    @Environment(\.colorScheme) var scheme: ColorScheme
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            
            SignInWithAppleButton { request in
                viewModel.requestAppleSignUp(request: request)
            } onCompletion: { result in
                viewModel.completeAppleSignUp(result: result)
            }
            .frame(width: 200, height: 50)
            .signInWithAppleButtonStyle(scheme == .dark ? .white : .black)

        }
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: AuthViewModel())
    }
}
