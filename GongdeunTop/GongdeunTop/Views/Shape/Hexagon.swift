//
//  Hexagon.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/18.
//

import SwiftUI

struct Hexagon: Shape {
    var radius: CGFloat
    
    
    init(radius: CGFloat) {
        self.radius = radius
    }
    
    let points: [CGPoint] = [.init(x: 0.5, y: -sqrt(3 / 4)),
                             .init(x: -0.5, y: -sqrt(3 / 4)),
                             .init(x: -1, y: 0),
                             .init(x: -0.5, y: sqrt(3 / 4)),
                             .init(x: 0.5, y: sqrt(3 / 4))]
     
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: radius, y: 0))
        for point in points {
            let x = point.x * radius
            let y = point.y * radius
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.closeSubpath()
        
        
        return path
    }
}


struct MyShape: View {
    var body: some View {
        Hexagon(radius: 100)
            .stroke()
            .offset(x:100, y: 100)
    }
}

struct MyShape_Previews: PreviewProvider {
    static var previews: some View {
        MyShape()
    }
}
