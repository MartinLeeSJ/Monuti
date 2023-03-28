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
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let sessionWidth = width / CGFloat(viewModel.numOfSessions) - 15
            VStack {
                Text("총 \(viewModel.getTotalTime())분")
                    .font(.title)
                    .bold()
                
                HStack {
                    ForEach(0 ..< viewModel.numOfSessions, id: \.self) { _ in
                        HStack(spacing: 3) {
                            Rectangle()
                                .foregroundColor(.pink)
                                .frame(width: sessionWidth * concentrationRatio)
                            Rectangle()
                                .foregroundColor(.orange)
                                .frame(width: sessionWidth * refreshRatio)
                        }
                        .frame(width: sessionWidth)
                    }
                }
                .frame(height: 40)
                .padding(.bottom, 40)
                
                HStack {
                    Text("세션 수")
                        .font(.headline)
                    Stepper(value: $viewModel.numOfSessions, in: 3...6, step: 1) {
                        Text("\(viewModel.numOfSessions)개")
                    }
                }
                
                HStack{
                    Text("집중")
                        .font(.headline)
                    
                    Stepper(value: $viewModel.concentrationTime, in: 15...50, step: 5) {
                        Text("\(viewModel.concentrationTime)분")
                    } onEditingChanged: { _ in
                        viewModel.setRemainSeconds()
                    }
                }
                
                HStack {
                    Text("휴식")
                        .font(.headline)
                    Stepper(value: $viewModel.refreshTime, in: 5...10, step: 1) {
                        Text("\(viewModel.refreshTime)분")
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
