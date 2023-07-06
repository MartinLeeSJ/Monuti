//
//  SetTimeForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/18.
//

import SwiftUI


struct SetTimeForm: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var manager: TimerManager
    
    private var concentrationTimeRatio: CGFloat {
        CGFloat(manager.timeSetting.concentrationTime) / CGFloat(manager.getTotalMinute())
    }
    
    private var restTimeRatio: CGFloat {
        CGFloat(manager.timeSetting.restTime) / CGFloat(manager.getTotalMinute())
    }
    
    private var longRefreshTimeRatio: CGFloat {
        CGFloat(manager.timeSetting.longRefreshMinute) / CGFloat(manager.getTotalMinute())
    }
    
    var body: some View {
        VStack {
            Text("totalTime\(manager.getTotalMinute())")
                .font(.title)
                .bold()
            
            drawGraph()
            
            sessionStepper
            
            concentrationTimeStepper
            
            restTimeStepper
            
            Toggle(isOn: $manager.timeSetting.willGetLongRefresh) {
                Text("setTime_long_refresh?")
                    .font(.caption)
            }
            .tint(themeManager.getColorInPriority(of: .accent))
            
        }
        .padding(16)
    }
    
    
    @ViewBuilder
    func drawGraph() -> some View {
        GeometryReader { geo in
            let width = geo.size.width
            HStack(spacing: 0) {
                ForEach(1...manager.timeSetting.numOfSessions, id: \.self) { session in
                    let isLastSession: Bool = session == (0...manager.timeSetting.numOfSessions).upperBound
                    var sessionRatio: CGFloat {
                        concentrationTimeRatio + (isLastSession ? longRefreshTimeRatio : restTimeRatio)
                    }
                    var sessionWidth: CGFloat {
                        width * sessionRatio
                    }
                    
                    var concentrationTimeWidth: CGFloat {
                        width * concentrationTimeRatio - 4
                    }
                    
                    var restTimeWidth: CGFloat {
                        width * (isLastSession ?  longRefreshTimeRatio : restTimeRatio) - 4
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
                           bound: TimerBasicPreset.sessionsBound,
                           step: TimerBasicPreset.sessionStep)
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
            
            SetTimeStepper(stepValue: $manager.timeSetting.concentrationTime,
                           bound: TimerBasicPreset.concentrationTimeBound,
                           step: TimerBasicPreset.concentrationTimeStep)
                .onChange(of: manager.timeSetting.concentrationTime) { _ in
                    manager.setTimerRemainSeconds()
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
            SetTimeStepper(stepValue: $manager.timeSetting.restTime,
                           bound: TimerBasicPreset.restTimeBound,
                           step: TimerBasicPreset.restTimeStep)
            
        }
    }
}

struct SetTimeStepper: View  {
    @Binding var stepValue: Int
    let bound: ClosedRange<Int>
    let step: Int.Stride
    
    var isLowerBound: Bool {
        stepValue == bound.lowerBound || !(bound ~= stepValue - step)
    }
    
    var isUpperBound: Bool {
        stepValue == bound.upperBound || !(bound ~= stepValue + step)
    }
    
    func countUp() {
        guard bound ~= stepValue + step else { return }
        stepValue += step
    }
    
    func countDown() {
        guard bound ~= stepValue - step else { return }
        stepValue -= step
    }
 
    var body: some View {
        HStack(spacing: 8) {
            Button {
                countDown()
            } label: {
                Image(systemName: "minus")
                    .frame(minWidth: 33, minHeight: 25)
            }
            .disabled(isLowerBound)
            .contentShape(Rectangle())
            
            Divider()
                .padding(.vertical, 8)
            
            Text("\(stepValue)")
                .frame(minWidth: 33, maxWidth: 33)
            
            Divider()
                .padding(.vertical, 8)
            Button {
                countUp()
            } label: {
                Image(systemName: "plus")
                    .frame(minWidth: 33, minHeight: 25)
            }
            .disabled(isUpperBound)
            .contentShape(Rectangle())
        }
        .tint(Color("basicFontColor"))
        .padding(.horizontal, 8)
        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 10))
        .frame(minHeight: 33, maxHeight: 33)
    }
}

struct SetTimeView_Previews: PreviewProvider {
    struct Container: View {
        @StateObject var themeManger = ThemeManager()
        @ObservedObject var timerManager = TimerManager()
        
        var body: some View {
            SetTimeForm(manager: timerManager)
                .environmentObject(themeManger)
        }
    }
    
    struct StepperContainer: View {
        @State var value: Int = 0
        var body: some View {
            SetTimeStepper(stepValue: $value, bound: 0...5, step: 1)
        }
    }
    static var previews: some View {
        Container()
        StepperContainer()
    }
}
