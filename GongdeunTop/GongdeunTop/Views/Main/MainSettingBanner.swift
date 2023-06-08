//
//  MainSettingBanner.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/07.
//

import SwiftUI

struct MainSettingBanner: View {
    let todoCount: Int
    let numOfSessions: Int
    let totalTime: Int

    var body: some View {
        HStack {
            Text("todo_counts \(todoCount)") + Text("sessions\(numOfSessions)") + Text("totalTime\(totalTime)")
        }
        .font(.caption)
        .padding(8)
        .background(in: Capsule())
        .backgroundStyle(.ultraThinMaterial)
    }
}


