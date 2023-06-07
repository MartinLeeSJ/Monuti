//
//  TargetList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/13.
//

import SwiftUI


struct TargetList: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var targetStore: TargetStore
    
    
    var body: some View {
        ZStack {
            themeManager.getColorInPriority(of: .background)
                .ignoresSafeArea(.all)
            List(targetStore.targets) { target in
                TargetListCell(target: target)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 8, leading: 16, bottom: 4, trailing: 16))
            }
            .listStyle(.plain)
        }
    }
}



struct TargetView_Previews: PreviewProvider {
    static var previews: some View {
        TargetList(targetStore: TargetStore())
            .environmentObject(ThemeManager())
    }
}
