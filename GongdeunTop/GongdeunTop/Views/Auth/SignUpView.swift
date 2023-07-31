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
    @ObservedObject var manager: AuthManager
    @State private var text: String = ""
    let finalText = String(localized: "Monuti_Intro")
    
    private func typeText(at position: Int = 0) {
        if position == 0 {
            text = ""
        }
        
        if position < finalText.count {
            // Run the code inside the DispatchQueue after 0.2s
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                text.append(finalText[position])
                typeText(at: position + 1)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color("GTBlue1")
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Image("AppLogoBlue")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 1.2)
                    .overlay(alignment: .leading) {
                        Text(text)
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .blendMode(.overlay)
                    }
                
                Spacer()
                
                Button("개인정보 처리방침") {
                    
                }
                
                SignInWithAppleButton { request in
                    manager.requestAppleSignUp(request: request)
                } onCompletion: { result in
                    manager.completeAppleSignUp(result: result)
                }
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(height: 50)
                .padding()
                .padding(.bottom)

            }
            .onAppear { typeText() }
        }
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(manager: AuthManager())
    }
}
