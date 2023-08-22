//
//  ThemeManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/03.
//

import Foundation
import SwiftUI

enum ColorThemes: String, Identifiable, CaseIterable {
    case blueOcean = "GTBlueOcean"
    case lemonGrass = "GTLemonGrass"
    case forest = "GTForest"
    
    var id: Self { self }
    
    var representativeName: String {
        switch self {
        case .blueOcean: return "BlueOcean"
        case .lemonGrass: return "LemonGrass"
        case .forest: return "Forest"
        }
    }
    
    var localizedStringKey: LocalizedStringKey {
        return LocalizedStringKey(self.representativeName)
    }
    
    var logoImage: Image {
        return Image("AppLogo\(representativeName)")
    }
    
    static var priorityRange = 0...4
}

enum ColorPriority: Int, Identifiable, CaseIterable {
    case background = 0
    case weak
    case medium
    case solid
    case accent
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .background: return "background"
        case .weak: return "weak"
        case .medium: return "medium"
        case .solid: return "solid"
        case .accent: return "accent"
        }
    }
}

class ThemeManager: ObservableObject {
    @Published var theme: ColorThemes = ColorThemes(rawValue: UserDefaults.standard.string(forKey: "colorTheme") ?? "GTBlueOcean") ?? .blueOcean
    
    func changeTheme(as newTheme: ColorThemes) {
        UserDefaults.standard.set(newTheme.rawValue, forKey: "colorTheme")
        theme = newTheme
    }
    
    func colorInPriority(in priorityOf: ColorPriority) -> Color {
        Color("\(theme.rawValue)\(priorityOf.rawValue)")
    }
    
    static func colorInPriority(of theme: ColorThemes, in priorityOf: ColorPriority) -> Color {
        Color("\(theme.rawValue)\(priorityOf.rawValue)")
    }
    
    func componentColor() -> Color {
        Color("\(theme.rawValue)Components")
    }
    
    func sheetBackgroundColor() -> Color {
        Color("\(theme.rawValue)SheetBackground")
    }
    
    func timerDigitAndButtonColor() -> Color {
        Color("\(theme.rawValue)\(ColorPriority.accent.rawValue)")
    }
    
    func appLogoImage() -> Image {
        theme.logoImage
    }
}
