//
//  TargetAndToDoList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/09/24.
//

import SwiftUI

struct TargetAndToDoList: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var targetManager: TargetManager
    @EnvironmentObject private var todoManager: ToDoManager
    
    var body: some View {
        ZStack {
            themeManager.colorInPriority(in: .background)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: .spacing(of: .normal)) {
                    ForEach(targetManager.targets, id: \.self) { target in
                        Text(target.title)
                    }
                }
                .padding()
            }
        }
    }
}

struct TargetAndToDoList_Previews: PreviewProvider {
    static var previews: some View {
        TargetAndToDoList()
            .environmentObject(ThemeManager())
            .environmentObject(TargetManager())
            .environmentObject(ToDoManager())
    }
}
