//
//  RoundedHexagon.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/04.
//

import SwiftUI

struct RoundedHexagon: Shape {
    var radius: Double
    var cornerRadius: Double

    init(radius: Double, cornerRadius: Double) {
        self.radius = radius
        self.cornerRadius = cornerRadius
    }
    
    func path(in rect: CGRect) -> Path {
        let originX: CGFloat = rect.width / 2
        let originY: CGFloat = rect.height / 2
        
        var path = Path()
        var degree: Double = 30.0
        
        path.move(to: CGPoint(x: radius * cos(Angle(degrees: degree).radians),
                              y: 0))
        
        while degree <= 330 {
            /// 커브가 시작되는 지점과 중심사이 거리
            let curveRadius: Double = radius * cos(Angle(degrees: 30).radians) / cos(Angle(degrees: 30 - cornerRadius).radians)
            let startRadian: Double = Angle(degrees: degree - cornerRadius).radians
            let controlPointRadian: Double = Angle(degrees: degree).radians
            let endRadian: Double = Angle(degrees: degree + cornerRadius).radians
            
            
            path.addLine(to: CGPoint(x: curveRadius * cos(startRadian),
                                     y: curveRadius * sin(startRadian)))
            
            path.addQuadCurve(to: CGPoint(x: curveRadius * cos(endRadian),
                                          y: curveRadius * sin(endRadian)),
                              control: CGPoint(x: radius * cos(controlPointRadian),
                                               y: radius * sin(controlPointRadian)))
                              
            degree += 60.0
        }
        
        path.closeSubpath()
        
        return path.offsetBy(dx: originX, dy: originY)
    }
}
