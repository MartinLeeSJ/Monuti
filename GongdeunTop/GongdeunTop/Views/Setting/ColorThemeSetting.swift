//
//  ColorThemeSetting.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/02.
//

import SwiftUI

struct ColorThemeSetting: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    private let columns: [GridItem] =  Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ZStack {
            themeManager.sheetBackgroundColor()
                .ignoresSafeArea()
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(ColorThemes.allCases) { colorTheme in
                    Button {
                        themeManager.changeTheme(as: colorTheme)
                    } label: {
                        GeometryReader { geo in
                            let width = geo.size.width
                            let hexagonWidth = width / CGFloat(ColorPriority.allCases.count)
                            HStack(spacing: 0) {
                                ForEach(ColorPriority.allCases) { priority in
                                    RoundedHexagon(radius: hexagonWidth / 2, cornerAngle: 10)
                                        .foregroundColor(ThemeManager.colorInPriority(of: colorTheme, in: priority))
                                }
                            }
                            
                        }
                        .padding()
                        .background(colorScheme == .light ? .black : .white, in: RoundedRectangle(cornerRadius: 10) )
                    }
                    .overlay {
                        if themeManager.theme == colorTheme {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(themeManager.colorInPriority(in: .accent), lineWidth: 3)
                        }
                    }
                }
                
                ForEach(ColorThemes.allCases) { colorTheme in
                    Text(colorTheme.localizedStringKey)
                        .font(.headline)
                }
                
            }
            .padding()
        }
        
    }
}

struct ColorThemeSetting_Previews: PreviewProvider {
    static var previews: some View {
        ColorThemeSetting()
            .environmentObject(ThemeManager())
    }
}
