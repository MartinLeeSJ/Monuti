//
//  CubeHexagon.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/18.
//

import SwiftUI

struct CubeHexagon: Shape {
    var radius: CGFloat

    init(radius: CGFloat) {
        self.radius = radius
    }
    

    func path(in rect: CGRect) -> Path {
        let originX: CGFloat = rect.width / 2
        let originY: CGFloat = rect.height / 2
        
        var path = Path()
        let degree: Double = 30.0
        
        
        for index in 0..<6 {
            let x = radius * cos(Angle(degrees: degree + 60.0 * Double(index)).radians)
            let y = radius * sin(Angle(degrees: degree + 60.0 * Double(index)).radians)
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            if index % 2 == 1 {
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        path.closeSubpath()
        
        
        return path.offsetBy(dx: originX, dy: originY)
    }
}





