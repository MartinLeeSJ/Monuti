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
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: .spacing(of: .normal)) {
                        ForEach(cycles, id: \.self) {
                            cycle in
                            CycleListCell(cycle: cycle)
                                .tint(Color("basicFontColor"))
                        }
                    }
                }
                Spacer()
            }
    }
}

struct DayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DayDetailView(cycles: Cycle.previews)
    }
}
