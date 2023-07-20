//
//  IndividualTimeSettingForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/10.
//

import SwiftUI

struct IndividualTimeSettingForm: View  {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var manager: TimerManager
    
    @State private var currentSession: Int = 0
    @State private var concentrationMinute: Int = 25 
    @State private var restSeconds: Int = 5 * 60
    
    private func addNewSession() {
        manager.addNewSession()
        currentSession = manager.timeSetting.sessions.count - 1
    }
    
    
    var body: some View {
        VStack {
            SetTimeGraph(manager: manager, currentFocusedIndex: $currentSession)
            Spacer()
            TabView(selection: $currentSession) {
                ForEach(manager.timeSetting.sessions.indices, id: \.self) { index in
                    if index < manager.timeSetting.sessions.count {
                        VStack(spacing: 8) {
                            HAlignment(alignment: .leading) {
                                Text("Session \(index + 1)")
                                    .font(.headline)
                            }
                            .padding(.bottom, 16)
                            
                            HStack {
                                Text("setTime_concentration")
                                    .font(.subheadline.bold())
                                Spacer()
                                SetTimePicker(time: $manager.timeSetting.sessions[index].concentrationSeconds,
                                              in: SetTimeContraint.looseConcentrationSecondBound)
                            }
                            
                            Divider()
                                .padding(.bottom, 8)
                            
                            HStack {
                                Text("setTime_rest")
                                    .font(.subheadline.bold())
                                Spacer()
                                SetTimePicker(time: $manager.timeSetting.sessions[index].restSeconds,
                                              in: SetTimeContraint.looseRestSecondBound)
                            }
                        }
                        .tag(index)
                        .padding()
                        .overlay(alignment: .topTrailing) {
                            Button {
                                manager.removeSession(at: index)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .offset(x: -16, y: 8)
                        }
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
        IndividualTimeSettingForm(manager: TimerManager())
            .environmentObject(ThemeManager())
    }
}
