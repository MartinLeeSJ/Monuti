//
//  TimerView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct TimerView: View {
    let initialSecond: Int = 25 * 60
    @State private var remainSecond: Int = 25 * 60
    @State private var isRunning: Bool = false
    @State private var timer: Timer?
    
    private var minute: String {
        let result: Int = Int(remainSecond / 60)
        if result < 10 {
            return "0" + String(result)
        } else {
            return String(result)
        }
    }
    
    private var second: String {
        let result: Int = remainSecond % 60
        if result < 10 {
            return "0" + String(result)
        } else {
            return String(result)
        }
    }
    
    private var endDegree: Double {
        return Double(remainSecond) / Double(initialSecond) * 360.0
    }
    
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 2) {
                Text(minute)
                Text(":")
                Text(second)
            }
            .font(.largeTitle)
            .padding(.bottom, 25)
            
            Button {
                if isRunning {
                    timer?.invalidate()
                } else {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        print(endDegree)
                        if remainSecond > 0 {
                            remainSecond -= 1
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
                        remainSecond = initialSecond
                    } label: {
                        Image(systemName: "chevron.backward.to.line")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.right.to.line")
                            .font(.title)
                            .foregroundColor(.gray)
                    }

                }
                .frame(width: 160)
            }
            
            
            
        }
        .frame(width: 160)
        .background {
            Circle()
                .foregroundColor(.GTyellowBright)
                .frame(width: 300, height: 300)
                .overlay {
                    CircularSector(endDegree: endDegree)
                        .foregroundColor(.GTyellow)
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
