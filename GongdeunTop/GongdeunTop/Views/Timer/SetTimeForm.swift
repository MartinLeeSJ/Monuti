//
//  SetTimeForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/18.
//

import SwiftUI
import Combine

struct SetTimeContraint {
    static let sessionsBound: ClosedRange<Int> = 1...5
    static let sessionStep: Int.Stride = 1
    
    static let concentrationTimeBound: ClosedRange<Int> = 15...50
    static let concentrationTimeStep: Int.Stride = 5
    
    static let restTimeBound: ClosedRange<Int> = 5...10
    static let restTimeStep: Int.Stride = 1
}

struct SetTimeForm: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var manager: TimerManager
    
    private var sessionIndex: Int {
        Int(manager.currentTimeIndex / 2)
    }
    
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
//            .onReceive(Just(manager.timeSetting.willGetLongRefresh)) { bool in
//                manager.toggleLastLongRefresh(isOn: bool)
//            }
            .tint(themeManager.getColorInPriority(of: .accent))
            
        }
        .padding(16)
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

struct SetTimeStepper: View  {
    @Binding var stepValue: Int
    let bound: ClosedRange<Int>
    let step: Int.Stride
    let onEditingChanged: (Bool) -> Void
    
    init(stepValue: Binding<Int>, bound: ClosedRange<Int>, step: Int.Stride, _ onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._stepValue = stepValue
        self.bound = bound
        self.step = step
        self.onEditingChanged = onEditingChanged
    }
    
    
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
                onEditingChanged(true)
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
                onEditingChanged(true)
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
