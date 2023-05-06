//
//  ColorThemeSetting.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/02.
//

import SwiftUI

struct ColorThemeSetting: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @Binding var modified: Bool
    var body: some View {
        VStack {
            ForEach(ColorPriority.allCases) { priority in
                themeManager.getColorInPriority(of: priority)
            }
            
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(ColorThemes.allCases) { colorTheme in
                    Button {
                        themeManager.changeTheme(as: colorTheme)
                    } label: {
                        Text(colorTheme.representativeName)
                            .font(.title)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 1)
                            }
                            .overlay {
                                if themeManager.theme == colorTheme {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(themeManager.getColorInPriority(of: .accent), lineWidth: 2)
                                }
                            }
                    }
                }
            }
            
        }
        .task {
            modified = false
        }
    }
}

struct ColorThemeSetting_Previews: PreviewProvider {
    static var previews: some View {
        ColorThemeSetting(modified: .constant(false))
    }
}
