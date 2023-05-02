//
//  ColorThemeSetting.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/02.
//

import SwiftUI

struct ColorThemeSetting: View {
    @AppStorage("theme") private var theme: String = "Blue"
    @Binding var modified: Bool
    var body: some View {
        VStack {
            ForEach(1..<6) { priority in
                Color.themes.getThemeColor(priority)
                    .frame(width: 30, height: 30)
            }
            
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(ColorThemes.allCases) { color in
                    Button {
                        theme = color.rawValue
                        modified = true
                        
                    } label: {
                        Text(color.rawValue)
                            .font(.title)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 1)
                            }
                            .overlay {
                                if theme == color.rawValue {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.themes.getThemeColor(5), lineWidth: 2)
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
