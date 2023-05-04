//
//  CircularSector.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/20.
//

import Foundation
import SwiftUI


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
