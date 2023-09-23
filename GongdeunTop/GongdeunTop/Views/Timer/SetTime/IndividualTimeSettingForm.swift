//
//  IndividualTimeSettingForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/10.
//

import SwiftUI

struct IndividualTimeSettingForm: View  {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var manager: TimerSettingManager
    
    @State private var currentSession: Int = 0
    @State private var isLoading: Bool = false
    
    
    
    private func addNewSession() {
        isLoading = true
        manager.addNewSession()
        currentSession = manager.timeSetting.sessions.count - 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isLoading = false
        }
    }
    
    private var hasReachedSessionLimit: Bool {
        manager.timeSetting.numOfSessions == TimerSettingContraint.looseSessionsBound.upperBound
    }
    
    
    var body: some View {
        VStack {
            SetTimeGraph(manager: manager, currentFocusedIndex: $currentSession)
            Spacer()
            TabView(selection: $currentSession) {
                ForEach(manager.timeSetting.sessions.indices, id: \.self) { index in
                    if !isLoading {
                        VStack(spacing: 8) {
                            HStack(spacing: 16) {
                                Text("Session \(index + 1)")
                                    .font(.headline)
                                Spacer()
                                if index != 0 {
                                    Button(role: .destructive) {
                                        manager.removeSession(at: index)
                                    } label: {
                                        Text("Delete")
                                    }
                                    .tint(.red)
                                }
                                if index == (manager.timeSetting.sessions.endIndex - 1) {
                                    Button {
                                        addNewSession()
                                    } label: {
                                        Text("Add")
                                    }
                                    .disabled(hasReachedSessionLimit)
                                }
                            }
                            .padding(.bottom, 16)
                            
                            HStack {
                                Text("setTime_concentration")
                                    .font(.subheadline.bold())
                                Spacer()
                                SetTimePicker(time: $manager.timeSetting.sessions[index].concentrationSeconds,
                                              in: TimerSettingContraint.looseConcentrationSecondBound,
                                              secondStride: 5)
                            }
                            
                            Divider()
                                .padding(.bottom, 8)
                            
                            HStack {
                                Text("setTime_rest")
                                    .font(.subheadline.bold())
                                Spacer()
                                SetTimePicker(time: $manager.timeSetting.sessions[index].restSeconds,
                                              in: TimerSettingContraint.looseRestSecondBound,
                                              secondStride: 5)
                            }
                        }
                        .tag(index)
                        .padding()
                    } else {
                        ProgressView()
                    }
                }
            }
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            Spacer()
        }
    }
}



struct IndividualTimeSettingForm_Previews: PreviewProvider {
    static var previews: some View {
        IndividualTimeSettingForm(manager: TimerSettingManager())
            .environmentObject(ThemeManager())
    }
}
