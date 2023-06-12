//
//  TargetDetailView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/12.
//

import SwiftUI

struct TargetDetailView: View {
    let target: Target
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TargetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TargetDetailView(target: Target(title: "", subtitle: "", createdAt: Date.now, startDate: Date.now, dueDate: Date.now, todos: [], achievement: 0, memoirs:  ""))
    }
}
