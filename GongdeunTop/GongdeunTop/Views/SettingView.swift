//
//  SettingView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/01.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("theme") private var theme: String = "Blue"
    var body: some View {
        VStack {
            ForEach(1..<6) { priority in
                Color.getThemeColor(priority)
                    .frame(width: 30, height: 30)
            }
            
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(ColorThemes.allCases) { color in
                    Button {
                        theme = color.rawValue
                    } label: {
                        Text(color.rawValue)
                            .font(.title)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 1)
                            }
                    }
                    
                    
                }
            }
            
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
