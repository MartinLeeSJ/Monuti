//
//  ColorThemeSetting.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/02.
//

import SwiftUI

struct ColorThemeSetting: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            ForEach(ColorPriority.allCases) { priority in
                themeManager.colorInPriority(of: priority)
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
                                        .stroke(themeManager.colorInPriority(of: .accent), lineWidth: 2)
                                }
                            }
                    }
                }
            }
            
        }
        
    }
}

struct ColorThemeSetting_Previews: PreviewProvider {
    static var previews: some View {
        ColorThemeSetting()
    }
}
