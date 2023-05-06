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
    
    var representativeName: String {
        switch self {
        case .blue: return "Blue"
        case .yellow: return "Yellow"
        }
    }
    
    static var priorityRange = 0...5
}

enum ColorPriority: Int, Identifiable, CaseIterable {
    case background = 1
    case weak
    case medium
    case solid
    case accent
    
    var id: Self { self }
}

class ThemeManager: ObservableObject {
    @Published var theme: ColorThemes = ColorThemes(rawValue: UserDefaults.standard.string(forKey: "colorTheme") ?? "GTBlue") ?? .blue
    
    func changeTheme(as newTheme: ColorThemes) {
        UserDefaults.standard.set(newTheme.rawValue, forKey: "colorTheme")
        theme = newTheme
    }
    
    func getColorInPriority(of priority: ColorPriority) -> Color {
        Color("\(theme.rawValue)\(priority.rawValue)")
    }
    
//    static func getColorTest(priority: ColorPriority) -> String {
//        let detectedTheme: String = UserDefaults.standard.string(forKey: "colorTheme") ?? "GTBlue"
//        return "\(detectedTheme)\(priority.rawValue)"
//    }
}


//extension Color {
//    init(priority: ColorPriority) {
//        self.init(ThemeManager.getColorTest(priority: priority))
//    }
//}
