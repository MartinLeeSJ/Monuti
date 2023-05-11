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
    @ObservedObject var viewModel: AuthManager
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Hello, World!")
            
            Spacer()
            
            Button("개인정보 처리방침") {
                
            }
            
            SignInWithAppleButton { request in
                viewModel.requestAppleSignUp(request: request)
            } onCompletion: { result in
                viewModel.completeAppleSignUp(result: result)
            }
            .signInWithAppleButtonStyle(.whiteOutline)
            .frame(height: 50)
            .padding()
            .padding(.bottom)

        }
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: AuthManager())
    }
}
