//
//  TimerView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct TimerView: View {
    @State private var remainSecond: Int = 25 * 60
    @State private var isRunning: Bool = false
    @State private var timer: Timer?
    
    private var minute: String {
        var result: Int = Int(remainSecond / 60)
        if result < 10 {
            return "0" + String(result)
        } else {
            return String(result)
        }
    }
    
    private var second: String {
        var result: Int = remainSecond % 60
        if result < 10 {
            return "0" + String(result)
        } else {
            return String(result)
        }
    }
    
    
    var body: some View {
        VStack {
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
                        if remainSecond > 0 {
                            remainSecond -= 1
                        }
                    }
                }
                isRunning.toggle()
            } label: {
                Image(systemName: isRunning ?  "pause.fill" : "play.fill")
                    .font(.title)
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
