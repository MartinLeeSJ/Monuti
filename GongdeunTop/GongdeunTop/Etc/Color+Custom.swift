//
//  Color+Custom.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import Foundation
import SwiftUI

enum ColorThemes: String, Identifiable, CaseIterable {
    case blue = "Blue"
    case yellow = "Yellow"
    
    var id: Self { self }
}

extension Color {
    
    static let themes = ColorTheme()
    
    static let GTyellow: Self = Color(hue: 0.143, saturation: 0.296, brightness: 0.978)
    static let GTyellowBright: Self = Color(hue: 0.141, saturation: 0.143, brightness: 0.984)
    
    static let GTGreen: Self = Color(red: 207, green: 234, blue: 179)
    
    static let GTDenimBlue: Self = Color(hue: 0.558, saturation: 0.213, brightness: 0.914)
    static let GTDenimNavy: Self = Color(hue: 0.648, saturation: 0.626, brightness: 0.594)
    static let GTPastelBlue: Self = Color(hue: 0.558, saturation: 0.208, brightness: 0.967)
    
    static let GTWeakBlue: Self = Color(hue: 0.558, saturation: 0.208, brightness: 0.967)
    static let GTGoodBlue: Self = Color(hue: 0.558, saturation: 0.328, brightness: 0.927)
    static let GTSolidBlue: Self = Color(hue: 0.558, saturation: 0.448, brightness: 0.887)
    

    
    static let GTEnergeticOrange: Self = Color(hue: 0.05, saturation: 0.927, brightness: 0.987)
    
    static let GTWarmGray: Self = Color(hue: 44/360, saturation: 0.03, brightness: 0.94)
}


struct ColorTheme {
    func getThemeColor(_ priority: Int) -> Color {
        guard (1...5).contains(priority) else {
            print("Use priority in 1...5")
            return Color.black
        }
        
        if let stored = UserDefaults.standard.string(forKey: "theme"), let theme = ColorThemes(rawValue: stored)?.rawValue {
            
            return Color("GT\(theme)\(priority)")
        } else {
            return Color("GTBlue\(priority)")

        }
    }
}
