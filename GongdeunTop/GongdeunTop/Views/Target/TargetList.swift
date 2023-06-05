//
//  TargetList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/13.
//

import SwiftUI


struct TargetList: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var targetStore = TargetStore()
    
    
    var body: some View {
        ZStack {
            themeManager.getColorInPriority(of: .background)
                .ignoresSafeArea(.all)
            VStack {
                ScrollView {
                    ForEach(targetStore.targets, id: \.self) { target in
                        TargetListCell(target: target)
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            targetStore.subscribeTargets()
        }
        .onDisappear {
            targetStore.unsubscribeTargets()
        }
    }
}



struct TargetView_Previews: PreviewProvider {
    static var previews: some View {
        TargetList()
            .environmentObject(ThemeManager())
    }
}
