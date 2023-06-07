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
            List {
                ForEach(Array(zip(targetStore.targets.indices, targetStore.targets)), id: \.0) { index, target in
                    let isLastIndex: Bool = index == targetStore.targets.count - 1
                    TargetListCell(target: target)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 8,
                                             leading: 16,
                                             bottom: 4,
                                             trailing: 16))
                    if isLastIndex {
                        Spacer()
                            .frame(height: 36)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            
                    }
                }
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
