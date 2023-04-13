//
//  SetTimeForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/18.
//

import SwiftUI


struct SetTimeForm: View {
    @ObservedObject var viewModel: TimerViewModel
    
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
                Text("총 \(viewModel.getTotalTime())분")
                    .font(.title)
                    .bold()
                
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
                
                HStack {
                    Capsule().fill(.gray).frame(width: 20, height: 15)
                    Text("세션 수")
                        .font(.headline)
                    Stepper(value: $viewModel.numOfSessions, in: 3...6, step: 1) {
                        HStack {
                            Text("\(viewModel.numOfSessions)개")
                            Text("3~6개")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                HStack{
                    Rectangle().fill(.pink).frame(width: 20, height: 15)
                    Text("집중")
                        .font(.headline)
                    
                    Stepper(value: $viewModel.concentrationTime, in: 15...50, step: 5) {
                        HStack {
                            Text("\(viewModel.concentrationTime)분")
                            Text("15~25분")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    } onEditingChanged: { _ in
                        viewModel.setRemainSeconds()
                    }
                }
                
                HStack {
                    Rectangle().fill(.orange).frame(width: 20, height: 15)
                    Text("휴식")
                        .font(.headline)
                    Stepper(value: $viewModel.refreshTime, in: 5...10, step: 1) {
                        HStack {
                            Text("\(viewModel.refreshTime)분")
                            Text("5~10분, 마지막 휴식 30분")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
            }
        }
        .padding()
    }
}

struct SetTimeView_Previews: PreviewProvider {
    static var previews: some View {
        SetTimeForm(viewModel: TimerViewModel())
    }
}
