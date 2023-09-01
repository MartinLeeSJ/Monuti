//
//  DayDetailView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/08/23.
//

import SwiftUI

struct DayDetailView: View {
    let cycles: [Cycle]
    var body: some View {
        ScrollView {
            VStack {
                ForEach(cycles, id: \.self) {
                    cycle in
                    CycleListCell(cycleManager: CycleManager(cycle: cycle))
                        .tint(Color("basicFontColor"))
                }
            }
        }
    }
}

struct DayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DayDetailView(cycles: Cycle.previews)
    }
}
