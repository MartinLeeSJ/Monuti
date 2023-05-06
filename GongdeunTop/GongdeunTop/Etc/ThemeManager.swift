//
//  ThemeManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/03.
//

import Foundation
import SwiftUI

enum ColorThemes: String, Identifiable, CaseIterable {
    case blue = "GTBlue"
    case yellow = "GTYellow"
    
    var id: Self { self }
    
    static var priorityRange = 0...5
}

enum ColorPriority: Int {
    case background = 1
    case weak
    case medium
    case solid
    case accent
}

class ThemeManager: ObservableObject {
    @Published var theme: ColorThemes = ColorThemes(rawValue: UserDefaults.standard.string(forKey: "colorTheme") ?? "Blue") ?? .blue
    
    func changeTheme(as newTheme: ColorThemes) {
        UserDefaults.standard.set(newTheme.rawValue, forKey: "colorTheme")
        theme = newTheme
    }
    
    func getThemeColorInPriority(of priority: ColorPriority) -> Color {
        Color("\(theme.rawValue)\(priority.rawValue)")
    }
}
