//
//  SetTimeForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/18.
//

import SwiftUI


struct SetTimeForm: View {
    @ObservedObject var viewModel: TimerManager
    
    private var concentrationRatio: CGFloat {
        CGFloat(viewModel.concentrationTime) / CGFloat(viewModel.concentrationTime + viewModel.refreshTime)
    }
    
    private var refreshRatio: CGFloat {
        CGFloat(viewModel.refreshTime) / CGFloat(viewModel.concentrationTime + viewModel.refreshTime)
    }
    
    private var longRefreshRatio: CGFloat {
        CGFloat(30) / CGFloat(viewModel.concentrationTime + 30)
    }
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let sessionWidth = width / CGFloat(viewModel.numOfSessions + 1)
            VStack {
                Text("totalTime\(viewModel.getTotalTime())")
                    .font(.title)
                    .bold()
                
                graph(sessionWidth)
               
                sessionStepper
                
                concentrationTimeStepper
                
                restTimeStepper
                
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func graph(_ sessionWidth: CGFloat) -> some View {
        HStack(spacing: 5) {
            ForEach(0 ..< viewModel.numOfSessions, id: \.self) { session in
                let isLastSession: Bool = session == viewModel.numOfSessions - 1
                VStack(spacing: 5) {
                    HStack(spacing: 1) {
                        Rectangle()
                            .foregroundColor(.pink)
                            .frame(width: isLastSession ? sessionWidth * ( 1 - longRefreshRatio ): sessionWidth * concentrationRatio)
                        Rectangle()
                            .foregroundColor(.orange)
                            .frame(width: isLastSession ? sessionWidth * longRefreshRatio : sessionWidth * refreshRatio)
                    }
                    Capsule()
                        .frame(width: sessionWidth, height: 5)
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
              
            }
        }
        .frame(height: 48)
        .padding(.bottom, 40)
    }
    
    var sessionStepper: some View {
        HStack {
            Capsule().fill(.gray).frame(width: 20, height: 15)
            Text("setTime_session")
                .font(.headline)
            Stepper(value: $viewModel.numOfSessions, in: 3...6, step: 1) {
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
                viewModel.setRemainSeconds()
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
