//
//  Turret.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/02.
//

import SwiftUI

struct Turret: View {
    var color: Color

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            let upWidth: CGFloat = (width * 0.7) / 5
            let downWidth: CGFloat = (width * 0.3) / 4
            
            let upHeight: CGFloat = 0
            let downHeight: CGFloat = height * 0.3

            Path { path in
                
                // Barrel
                path.move(to: CGPoint(x: 0, y: downHeight * 2))
                
                path.addLine(to: CGPoint(x: 0, y: upHeight))
                
                path.addLine(to: CGPoint(x: upWidth, y: upHeight))
                
                path.addLine(to: CGPoint(x:upWidth, y: downHeight))
                
                path.addLine(to: CGPoint(x:upWidth + downWidth, y: downHeight))
                path.addLine(to: CGPoint(x:upWidth + downWidth, y: upHeight))
                
                path.addLine(to: CGPoint(x:2 * upWidth + downWidth, y: upHeight))
                path.addLine(to: CGPoint(x:2 * upWidth + downWidth, y: downHeight))
                
                path.addLine(to: CGPoint(x:2 * upWidth + 2 * downWidth, y: downHeight))
                path.addLine(to: CGPoint(x:2 * upWidth + 2 * downWidth, y: upHeight))
                
                path.addLine(to: CGPoint(x:3 * upWidth + 2 * downWidth, y: upHeight))
                path.addLine(to: CGPoint(x:3 * upWidth + 2 * downWidth, y: downHeight))
                
                path.addLine(to: CGPoint(x:3 * upWidth + 3 * downWidth, y: downHeight))
                path.addLine(to: CGPoint(x:3 * upWidth + 3 * downWidth, y: upHeight))
                
                path.addLine(to: CGPoint(x:4 * upWidth + 3 * downWidth, y: upHeight))
                path.addLine(to: CGPoint(x:4 * upWidth + 3 * downWidth, y: downHeight))
                
                path.addLine(to: CGPoint(x:4 * upWidth + 4 * downWidth, y: downHeight))
                path.addLine(to: CGPoint(x:4 * upWidth + 4 * downWidth, y: upHeight))
                
                path.addLine(to: CGPoint(x:5 * upWidth + 4 * downWidth, y: upHeight))
                path.addLine(to: CGPoint(x:5 * upWidth + 4 * downWidth, y: downHeight * 2))
                
                path.addLine(to: CGPoint(x:5 * upWidth + 4 * downWidth - 15, y: downHeight * 2))
                
                path.addLine(to: CGPoint(x:5 * upWidth + 4 * downWidth - 15, y: height))
                
                path.addLine(to: CGPoint(x: 15, y: height))
                
                path.addLine(to: CGPoint(x: 15, y: downHeight * 2))
                
                path.closeSubpath()
                
            }
            .fill(color)
//            .stroke(Color.black, lineWidth: 2)
        }
        
    }
}

struct Turret_Previews: PreviewProvider {
    static var previews: some View {
        Turret(color: .GTDenimBlue)
    }
}
