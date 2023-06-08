//
//  LauchScreen.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/12.
//

import SwiftUI

struct LauchScreen: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @ViewBuilder
    private var background: some View {
        themeManager.getColorInPriority(of: .background)
            .ignoresSafeArea(.all)
    }
    
    @ViewBuilder
    private var image: some View {
        themeManager.getAppLogoImage()
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 200)
    }
    
    var body: some View {
        ZStack {
           background
           image
        }
    }
}

struct LauchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LauchScreen()
            .environmentObject(ThemeManager())
    }
}
