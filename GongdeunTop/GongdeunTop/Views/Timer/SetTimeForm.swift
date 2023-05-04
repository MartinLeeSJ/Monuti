//
//  SetTimeForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/18.
//

import SwiftUI


struct SetTimeForm: View {
    @ObservedObject var viewModel: TimerManager
    
    private var concentrationTimeRatio: CGFloat {
        CGFloat(viewModel.concentrationTime) / CGFloat(viewModel.getTotalMinute())
    }
    
    private var refreshTimeRatio: CGFloat {
        CGFloat(viewModel.refreshTime) / CGFloat(viewModel.getTotalMinute())
    }
    
    private var longRefreshTimeRatio: CGFloat {
        CGFloat(30) / CGFloat(viewModel.getTotalMinute())
    }
    
    var body: some View {
        VStack {
            Text("totalTime\(viewModel.getTotalMinute())")
                .font(.title)
                .bold()
            
            drawGraph()
            
            sessionStepper
            
            concentrationTimeStepper
            
            restTimeStepper
            
        }
        .padding(16)
    }
    
    
    @ViewBuilder
    func drawGraph() -> some View {
        GeometryReader { geo in
            let width = geo.size.width
            HStack(spacing: 0) {
                ForEach(0 ..< viewModel.numOfSessions, id: \.self) { session in
                    let isLastSession: Bool = session == viewModel.numOfSessions - 1
                    var sessionRatio: CGFloat {
                        concentrationTimeRatio + (isLastSession ? longRefreshTimeRatio : refreshTimeRatio)
                    }
                    var sessionWidth: CGFloat {
                        width * sessionRatio
                    }
                    
                    HStack(spacing: 2) {
                        Rectangle()
                            .foregroundColor(.pink)
                            .frame(width: width * concentrationTimeRatio - 4,
                                   height: 48)
                        
                        Rectangle()
                            .foregroundColor(.orange)
                            .frame(width: width * (isLastSession ?  longRefreshTimeRatio : refreshTimeRatio) - 4,
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
            Stepper(value: $viewModel.numOfSessions, in: 2...5, step: 1) {
                HStack {
                    Text("setTime_session\(viewModel.numOfSessions)")
                        .font(.caption2)
                    Text("setTime_session_range")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    var concentrationTimeStepper: some View {
        HStack{
            Rectangle().fill(.pink).frame(width: 20, height: 15)
            Text("setTime_concentration")
                .font(.headline)
            
            Stepper(value: $viewModel.concentrationTime, in: 15...50, step: 5) {
                HStack {
                    Text("setTime_minute\(viewModel.concentrationTime)")
                        .font(.caption2)
                    Text("setTime_concentration_range")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } onEditingChanged: { _ in
                viewModel.setTimerRemainSeconds()
            }
        }
    }
    var restTimeStepper: some View {
        HStack {
            Rectangle().fill(.orange).frame(width: 20, height: 15)
            Text("setTime_rest")
                .font(.headline)
            Stepper(value: $viewModel.refreshTime, in: 5...10, step: 1) {
                HStack {
                    Text("setTime_minute\(viewModel.refreshTime)")
                        .font(.caption2)
                    Text("setTime_rest_range")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct SetTimeView_Previews: PreviewProvider {
    static var previews: some View {
        SetTimeForm(viewModel: TimerManager())
    }
}
