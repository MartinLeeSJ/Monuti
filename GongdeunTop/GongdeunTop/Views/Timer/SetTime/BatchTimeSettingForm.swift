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
            Text("totalTime\(manager.getTotalMinute())")
                .font(.title)
                .bold()
            
            drawGraph()
            
            sessionStepper
            concentrationTimeStepper
            restTimeStepper
            
            longRefreshToggle
            
            Spacer()
        }
    }
}
//MARK: - Graph
extension BatchTimeSettingForm {
    private func getConcentrationTimeRatio(ofSession index: Int) -> CGFloat {
        guard index < manager.timeSetting.numOfSessions else { return CGFloat(1)}
        let concetrationTime = CGFloat(manager.timeSetting.sessions[index].concentrationTime)
        let totalMinute = CGFloat(manager.getTotalMinute())
        return concetrationTime / totalMinute
    }
    
    private func getRestTimeRatio(ofSession index: Int) -> CGFloat {
        guard index < manager.timeSetting.numOfSessions else { return CGFloat(1)}
        let restTime = CGFloat(manager.timeSetting.sessions[index].restTime)
        let totalMinute = CGFloat(manager.getTotalMinute())
        return restTime / totalMinute
    }
    
    @ViewBuilder
    func drawGraph() -> some View {
        GeometryReader { geo in
            let width = geo.size.width
            HStack(spacing: 0) {
                ForEach(0..<manager.timeSetting.numOfSessions, id: \.self) { index in
                    var sessionRatio: CGFloat {
                        getConcentrationTimeRatio(ofSession: index) + getRestTimeRatio(ofSession: index)
                    }
                    var sessionWidth: CGFloat {
                        width * sessionRatio
                    }
                    
                    var concentrationTimeWidth: CGFloat {
                        width * getConcentrationTimeRatio(ofSession: index) - 4
                    }
                    
                    var restTimeWidth: CGFloat {
                        width * getRestTimeRatio(ofSession: index) - 4
                    }
                    
                    HStack(spacing: 2) {
                        Rectangle()
                            .foregroundColor(themeManager.getColorInPriority(of: .solid))
                            .frame(width: concentrationTimeWidth,
                                   height: 48)
                        
                        Rectangle()
                            .foregroundColor(themeManager.getColorInPriority(of: .medium))
                            .frame(width: restTimeWidth < 0 ? 0 : restTimeWidth,
                                   height: 48)
                    }
                    .padding(.horizontal, 5)
                    .frame(width: sessionWidth)
                    .overlay(alignment: .bottom) {
                        Capsule()
                            .frame(width: sessionWidth - 10, height: 5)
                            .foregroundColor(.gray)
                            .opacity(0.5)
                            .offset(y: 10)
                    }
                }
            }
            .frame(width: width)
            
        }
        .frame( height: 58)
        .padding(.bottom, 40)
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
                           bound: SetTimeContraint.sessionsBound,
                           step: SetTimeContraint.sessionStep)
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
            
            SetTimeStepper(stepValue: $manager.timeSetting.session.concentrationTime,
                           bound: SetTimeContraint.concentrationTimeBound,
                           step: SetTimeContraint.concentrationTimeStep) { _ in
                manager.mapAllSessions()
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
            SetTimeStepper(stepValue: $manager.timeSetting.session.restTime,
                           bound: SetTimeContraint.restTimeBound,
                           step: SetTimeContraint.restTimeStep) { _ in
                manager.mapAllSessions()
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
