//
//  SetTimeView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/18.
//

import SwiftUI

struct SetTimeView: View {
    @State private var sessions: Int = 4
    @State private var concentrationTime: Int = 25
    @State private var refreshTime: Int = 5
    
    var concentrationRatio: CGFloat {
        CGFloat(concentrationTime) / CGFloat(concentrationTime + refreshTime)
    }
    
    var refreshRatio: CGFloat {
        CGFloat(refreshTime) / CGFloat(concentrationTime + refreshTime)
    }
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let sessionWidth = width / CGFloat(sessions) - 15
            VStack {
                Text("총 \((concentrationTime + refreshTime) * sessions)분")
                    .font(.title)
                    .bold()
                
                HStack {
                    ForEach(0 ..< sessions, id: \.self) { _ in
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
                    Stepper(value: $sessions, in: 3...6, step: 1) {
                        Text("\(sessions)개")
                    }
                }
                
                HStack{
                    Text("세션 당")
                        .font(.headline)
                    Stepper(value: $concentrationTime, in: 15...50, step: 5) {
                        Text("\(concentrationTime)분")
                    }
                }
                
                HStack {
                    Text("쉬는시간")
                        .font(.headline)
                    Stepper(value: $refreshTime, in: 5...10, step: 1) {
                        Text("\(refreshTime)분")
                    }
                }
                
            }
        }
        .padding()
    }
}

struct SetTimeView_Previews: PreviewProvider {
    static var previews: some View {
        SetTimeView()
    }
}
