//
//  BatchTimeSettingForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/10.
//

import SwiftUI

struct BatchTimeSettingForm: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var manager: TimerSettingManager
    
    var body: some View {
        VStack {
            SetTimeGraph(manager: manager)
            
            HAlignment(alignment: .trailling) {
                if !manager.isDefaultSessionsSetting {
                    Button {
                        manager.resetToBasicSessions()
                    } label: {
                        Label("기본 설정으로 돌아가기", systemImage: "arrow.clockwise")
                            .font(.caption2)
                    }
                    .buttonStyle(.bordered)
                    .tint(themeManager.colorInPriority(in: .accent))
                }
            }
            .frame(minHeight: 60)
            
            sessionStepper
            concentrationTimeStepper
            restTimeStepper
            
            longRefreshToggle
            
            Spacer()
        }
        
    }
}


//MARK: - Stepper
extension BatchTimeSettingForm {
    var sessionStepper: some View {
        HStack {
            Capsule().fill(.gray).frame(width: 20, height: 15)
            Text("setTime_session")
                .font(.headline)
            Text("setTime_session_range")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            SetTimeStepper(stepValue: $manager.timeSetting.numOfSessions,
                           bound: TimerSettingContraint.sessionsBound,
                           step: TimerSettingContraint.sessionStep) { _ in
                
            } label: {
                Text("\(manager.timeSetting.numOfSessions)")
            }
        }
    }
    var concentrationTimeStepper: some View {
        HStack{
            Rectangle()
                .fill(themeManager.colorInPriority(in: .solid))
                .frame(width: 20, height: 15)
            Text("setTime_concentration")
                .font(.headline)
            
            Text("setTime_concentration_range")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            
            SetTimeStepper(stepValue: $manager.timeSetting.session.concentrationSeconds,
                           bound: TimerSettingContraint.concentrationSecondBound,
                           step: TimerSettingContraint.concentrationSecondStep) { _ in
                manager.mapAllSessions()
            } label: {
                Text("\(manager.getMinute(of: manager.timeSetting.session.concentrationSeconds))")
            }
        }
    }
    var restTimeStepper: some View {
        HStack {
            Rectangle()
                .fill(themeManager.colorInPriority(in: .medium))
                .frame(width: 20, height: 15)
            Text("setTime_rest")
                .font(.headline)
            Text("setTime_rest_range")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            SetTimeStepper(stepValue: $manager.timeSetting.session.restSeconds,
                           bound: TimerSettingContraint.restSecondBound,
                           step: TimerSettingContraint.restSecondStep) { _ in
                manager.mapAllSessions()
            } label: {
                Text("\(manager.getMinute(of: manager.timeSetting.session.restSeconds))")
            }
            
        }
    }
}

//MARK: - Toggle
extension BatchTimeSettingForm {
    var longRefreshToggle: some View {
        Toggle(isOn: $manager.timeSetting.willGetLongRefresh) {
            Text("setTime_long_refresh?")
                .font(.caption)
        }
        .onChange(of: manager.timeSetting.willGetLongRefresh) { bool in
            manager.toggleLastLongRefresh(isOn: bool)
        }
        .tint(themeManager.colorInPriority(in: .accent))
    }
}

struct BatchTimeSettingForm_Previews: PreviewProvider {
    static var previews: some View {
        BatchTimeSettingForm(manager: TimerSettingManager())
            .environmentObject(ThemeManager())
    }
}
