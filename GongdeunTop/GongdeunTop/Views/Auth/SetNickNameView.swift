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
    var body: some View {
        ZStack {
            themeManager.getColorInPriority(of: .background)
                .ignoresSafeArea()
            VStack {
                
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.6)
                    .overlay {
                        Image("AppLogoWithText")
                            .resizable()
                            .frame(width: 300, height: 300)
                    }
                    
                
                switch manager.nickNameRegisterState {
                case .newUser, .existingUser:
                    nickNameTextField
                        .transition(.slide)
                case .registering:
                    ProgressView()
                        .transition(.slide)
                case .greeting:
                    Text("환영합니다!")
                        .transition(.opacity.animation(.easeInOut))
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
                .font(.title3)
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
                .overlay(alignment: .bottomLeading) {
                    HStack {
                        Text("닉네임은 1글자 이상 8글자 이하로 만들어 주세요.")
                        if manager.nickName.isValidate {
                            Image(systemName: "checkmark")
                                .transition(.opacity.animation(.easeInOut))
                        }
                    }
                    .font(.footnote)
                    .foregroundColor(themeManager.getColorInPriority(of: .accent))
                    .offset(y: 24)
                    
                }
                
                Button("확인") {
                    manager.registerMemberNickName()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
                .tint(themeManager.getColorInPriority(of: .accent))
                .disabled(!manager.nickName.isValidate)
            }
            .padding()
        }
    }
}

struct SetNickNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetNickNameView(manager: AuthManager())
            .environmentObject(ThemeManager())
    }
}
