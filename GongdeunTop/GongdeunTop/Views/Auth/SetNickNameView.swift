//
//  SetNickNameView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/11.
//

import SwiftUI

struct SetNickNameView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var manager: AuthManager
    @State private var showGreet: Bool = false

    var body: some View {
        ZStack {
            themeManager.colorInPriority(of: .background)
                .ignoresSafeArea()
            VStack {
                Spacer()
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.6)
                    .overlay {
                        Image("AppLogoWithText")
                            .resizable()
                            .frame(width: 300, height: 300)
                    }
                    
                
                switch manager.nickNameRegisterState {
                case .newUser, .existingUser:
                    nickNameTextField
                case .registering:
                    registeringProgress
                }
                
                Spacer()
            }
            
            .padding()
        }
    }
}

extension SetNickNameView {
    var nickNameTextField: some View {
        Group {
            Text("당신을 어떻게 부르면 좋을까요?")
                .font(.headline)
                .fontWeight(.medium)
            
            
            HStack {
                TextField(text: $manager.nickName.name) {
                    Text("닉네임")
                        .font(.title3)
                }
                .textFieldStyle(.plain)
                .textInputAutocapitalization(.never)
                .frame(height: 40)
                .overlay(alignment: .trailing) {
                    if !manager.nickName.name.isEmpty {
                        Button {
                            manager.resetNickName()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.headline)
                        }
                        .tint(.secondary)
                        .offset(x: -5)
                    }
                }
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 1)
                }
                
                Button("확인") {
                    manager.registerMemberNickName()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
                .tint(themeManager.colorInPriority(of: .accent))
                .disabled(!manager.nickName.isValidate)
            }
            .overlay(alignment: .bottomLeading) {
                HStack {
                    Text("닉네임은 1글자 이상 8글자 이하로 만들어 주세요.")
                    if manager.nickName.isValidate {
                        Image(systemName: "checkmark")
                            .transition(.opacity.animation(.easeInOut))
                    }
                }
                .font(.footnote)
                .foregroundColor(themeManager.colorInPriority(of: .accent))
                .offset(y: 24)
                
            }
            .padding()
            .transition(.opacity.animation(.easeInOut))
        }
    }
    
    var registeringProgress: some View {
        VStack {
            if showGreet {
                Text("환영합니다 \(manager.nickName.name)님!")
                    .font(.headline)
                    .fontWeight(.medium)
            } else {
                ProgressView()
            }
        }
        .transition(.opacity.animation(.easeInOut))
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showGreet.toggle()
            }
        }
    }
}

struct SetNickNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetNickNameView(manager: AuthManager())
            .environmentObject(ThemeManager())
    }
}
