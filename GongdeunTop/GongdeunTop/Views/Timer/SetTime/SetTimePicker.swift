//
//  TimePicker.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/15.
//

import SwiftUI
import Combine

struct SetTimePicker: View {
    @Binding var time: Int
    @State private var minute: Int
    @State private var second: Int
    let minuteBound: Range<Int>
    let secondBound: Range<Int>
    
    init(time: Binding<Int>, in timeBound: Range<Int>) {
        self._time = time
        self.minute = Int(time.wrappedValue / 60)
        self.second = time.wrappedValue % 60
        self.minuteBound = SetTimeContraint.getMinuteBound(bound: timeBound)
        self.secondBound = 0..<59
    }
    
    private func computeTotalSeconds() {
        let total = self.minute * 60 + self.second
        time = total
    }
 
    var body: some View {
        HStack {
            Picker(selection: $minute) {
                ForEach(minuteBound, id: \.self) { now in
                    Text("\(now)")
                        .tag(now)
                }
            } label: {
                Text("\(minute)")
            }
            .pickerStyle(.menu)
            .onChange(of: minute) { _ in
                computeTotalSeconds()
            }

            Text("분")
            
            Picker(selection: $second) {
                ForEach(secondBound, id: \.self) { now in
                    Text("\(now)")
                        .tag(now)
                }
            } label: {
                Text("\(second)")
            }
            .pickerStyle(.menu)
            .onChange(of: second) { _ in
                computeTotalSeconds()
            }
            
            Text("초")
        }
     
    }
}

//struct TimePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        TimePicker(time: .constant(0), in: 0*60...50*60)
//    }
//}
