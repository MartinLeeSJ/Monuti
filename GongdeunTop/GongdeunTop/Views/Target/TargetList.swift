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
    @State private var isAddTargetSheetOn: Bool = false
    
    var body: some View {
            ZStack {
                themeManager.getColorInPriority(of: .background)
                    .ignoresSafeArea(.all)
                ScrollView {
                    ForEach(targetStore.targets, id: \.self) { target in
                        TargetListCell(target: target)
                    }
                }
                .padding()
            }
            .navigationTitle("단기목표")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        isAddTargetSheetOn.toggle()
                    } label: {
                        Text("추가")
                    }
                    .sheet(isPresented: $isAddTargetSheetOn) {
                        SetTargetForm()
                            .presentationDetents([.medium])
                    }
                }
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
