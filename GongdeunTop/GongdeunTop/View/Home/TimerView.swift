//
//  TimerView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var initialSecond: Int = 25 * 60
    @State var remainSecond: Int = 25 * 60
    var initialSeconds: [Int] = [25 * 60, 1 * 60, 25 * 60, 5 * 60, 25 * 60, 5 * 60, 25 * 60, 30 * 60 ]
    @State var remainSeconds: [Int] = [25 * 60, 1 * 60, 25 * 60, 5 * 60, 25 * 60, 5 * 60, 25 * 60, 30 * 60 ]
    
    @State private var timeIndex: Int = 0
    
    @State private var isRunning: Bool = false
    @State private var timer: Timer?
    
    private var minute: String {
        let result: Int = Int(remainSeconds[timeIndex] / 60)
        if result < 10 {
            return "0" + String(result)
        } else {
            return String(result)
        }
    }
    
    private var second: String {
        let result: Int = remainSeconds[timeIndex] % 60
        if result < 10 {
            return "0" + String(result)
        } else {
            return String(result)
        }
    }
    
    private var endDegree: Double {
        return Double(remainSeconds[timeIndex]) / Double(initialSeconds[timeIndex]) * 360.0
    }
    
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            VStack {
                Spacer()
                    .frame(height: height * 0.2)
                VStack(alignment: .center) {
                    
                    ZStack {
                        Text(minute)
                            .offset(x: -width * 0.1)
                        Text(":")
                        Text(second)
                            .offset(x: width * 0.1)
                    }
                    .font(.largeTitle)
                    .padding(.bottom, 25)
                    
                    Button {
                        if isRunning {
                            timer?.invalidate()
                        } else {
                            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                if remainSeconds[timeIndex] > 0 {
                                    remainSeconds[timeIndex] -= 1
                                } else {
                                    timer?.invalidate()
                                    isRunning = false
                                    if timeIndex < initialSeconds.count - 1 {
                                        timeIndex += 1
                                    }
                                    
                                }
                            }
                        }
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ?  "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .overlay {
                        HStack {
                            Button {
                                timer?.invalidate()
                                isRunning = false
                                remainSeconds[timeIndex] = initialSeconds[timeIndex]
                            } label: {
                                Image(systemName: "chevron.backward.to.line")
                                    .font(.title)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button {
                                timer?.invalidate()
                                isRunning = false
                                if timeIndex < initialSeconds.count - 1 {
                                    timeIndex += 1
                                }
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.title)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: width * 0.5)
                    }
                }
                .background {
                    Circle()
                        .foregroundColor(.GTyellowBright)
                        .frame(width: width * 0.8, height: width * 0.8)
                        .overlay {
                            CircularSector(endDegree: endDegree)
                                .foregroundColor(.GTyellow)
                        }
                }
                Spacer()
            }
            .frame(width: width, height: height)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem {
                Button {
                    dismiss()
                } label: {
                    Text("끝내기")
                }

            }
        }
    }
    
    
}


struct CircularSector: Shape {
  let startDegree: Double = 270
  var endDegree: Double
  var clockwise: Bool = false

  func path(in rect: CGRect) -> Path {
    var path = Path()
    let radius = max(rect.size.width, rect.size.height) / 2
      path.move(to: CGPoint(x: rect.midX, y: rect.midY))
      path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                  radius: radius,
                  startAngle: Angle(degrees: startDegree),
                  endAngle: Angle(degrees: endDegree + 270),
                  clockwise: clockwise)
      return path
  }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
