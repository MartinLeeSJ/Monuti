//
//  Countdown.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/26.
//

import SwiftUI

struct FirstCountdown: View {
    
    
    @State private var timeCount: Int = 3
    @State private var timeRemain: Double = 8.0
    @State private var timer: Timer? = nil
    
    
    @State private var offset: Double = 0.0
    @State private var opacity: Double = 0.0
    

       var body: some View {
           Color(.black)
               .opacity(0.8)
               .ignoresSafeArea()
               .overlay {
                   Text(timeCount == 0 ? "START!" : String(timeCount))
                       .font(.system(size: timeCount == 0 ? 32 : 64, weight: .heavy))
                       .foregroundColor(.white)
                       .background {
                           Circle()
                               .fill(Color.GTPastelBlue.opacity(0.3))
                               .frame(width: 150, height: 150)
                       }
                       .offset(y: offset)
                       .opacity(opacity)
               }
               .onAppear {
                       timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
                           if timeRemain > 0.0 {
                               timeRemain -= 0.2
                               
                               timeCount = Int(timeRemain / 2)
                               
                               
                               withAnimation(.linear){
                                   switch timeRemain - floor(timeRemain) {
                                   case 0.8..<1.0 where Int(timeRemain) % 2 == 1:
                                       offset = 0.0
                                       opacity = 0.5
                                       
                                       
                                   case 0.0..<0.8 where Int(timeRemain) % 2 == 1 :
                                       offset = -40.0
                                       opacity = 1.0
                                       
                                   case 0.0..<1.0 where timeCount == 0 :
                                       offset = -40.0
                                       opacity = 1.0
                                   default:
                                       offset = 0.0
                                       opacity = 0.0
                                       
                                   }
                               }
                               
                               
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
