//
//  Countdown.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/26.
//

import SwiftUI

struct FirstCountdown: View {
    @State private var timeCount: Int = 3
    @State private var timer: Timer? = nil
    
    @State private var rotation: Double = 0.0

       var body: some View {
           Text("\(timeCount)")
               .font(.system(size: 64))
               .onAppear {
                   timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                       if timeCount > 0 {
                          timeCount -= 1
                       } else {
                           timer.invalidate()
                       }
                   }
               }
       }
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        FirstCountdown()
    }
}
