//
//  BatchTimeSettingForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/10.
//

import SwiftUI

struct BatchTimeSettingForm: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var manager: TimerManager
    
    var body: some View {
        VStack {
            SetTimeGraph(manager: manager)
            
            Spacer()
            
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
//            SetTimeStepper(stepValue: $manager.timeSetting.,
//                           bound: SetTimeContraint.sessionsBound,
//                           step: SetTimeContraint.sessionStep) { _ in
//                
//            } label: {
//                Text("\(manager.timeSetting.numOfSessions)")
//            }
        }
    }
    var concentrationTimeStepper: some View {
        HStack{
            Rectangle()
                .fill(themeManager.getColorInPriority(of: .solid))
                .frame(width: 20, height: 15)
            Text("setTime_concentration")
                .font(.headline)
            
            Text("setTime_concentration_range")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            
            SetTimeStepper(stepValue: $manager.timeSetting.session.concentrationSeconds,
                           bound: SetTimeContraint.concentrationSecondBound,
                           step: SetTimeContraint.concentrationSecondStep) { _ in
                manager.mapAllSessions()
            } label: {
                Text("\(manager.getMinute(of: manager.timeSetting.session.concentrationSeconds))")
            }
        }
    }
    var restTimeStepper: some View {
        HStack {
            Rectangle()
                .fill(themeManager.getColorInPriority(of: .medium))
                .frame(width: 20, height: 15)
            Text("setTime_rest")
                .font(.headline)
            Text("setTime_rest_range")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            SetTimeStepper(stepValue: $manager.timeSetting.session.restSeconds,
                           bound: SetTimeContraint.restSecondBound,
                           step: SetTimeContraint.restSecondStep) { _ in
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
        .tint(themeManager.getColorInPriority(of: .accent))
    }
}

struct BatchTimeSettingForm_Previews: PreviewProvider {
    static var previews: some View {
        BatchTimeSettingForm(manager: TimerManager())
            .environmentObject(ThemeManager())
    }
}
