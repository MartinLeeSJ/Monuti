//
//  SetTimeForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/18.
//

import SwiftUI
import Combine

struct SetTimeContraint {
    static let looseSessionsBound: ClosedRange<Int> = 1...8
    static let sessionsBound: ClosedRange<Int> = 1...5
    static let sessionStep: Int.Stride = 1
    
    static let looseConcentrationTimeBound: ClosedRange<Int> = (1 * 60)...(50 * 60)
    static let concentrationTimeBound: ClosedRange<Int> = (15 * 60)...(50 * 60)
    static let concentrationTimeStep: Int.Stride = 5 * 60
    
    static let looseRestTimeBound: ClosedRange<Int> = 0...(30 * 60)
    static let restTimeBound: ClosedRange<Int> = (5 * 60)...(10 * 60)
    static let restTimeStep: Int.Stride = 1 * 60

}

struct SetTimeForm: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var manager: TimerManager
    
    private var sessionIndex: Int {
        Int(manager.currentTimeIndex / 2)
    }
    
    var body: some View {
        VStack {
            Picker("Mode", selection: $manager.mode) {
                ForEach(TimerManager.TimeSetMode.allCases) { mode in
                    Text(mode.rawValue)
                }
            }
            .pickerStyle(.segmented)

            switch manager.mode {
            case .batch: BatchTimeSettingForm(manager: manager)
            case .individual: IndividualTimeSettingForm(manager: manager)
            case .preset: PresetTimeSettingForm()
            }
        }
        .padding(16)
    }

}





struct SetTimeView_Previews: PreviewProvider {
    struct Container: View {
        @StateObject var themeManger = ThemeManager()
        @ObservedObject var timerManager = TimerManager()
        
        var body: some View {
            SetTimeForm(manager: timerManager)
                .environmentObject(themeManger)
        }
    }

    static var previews: some View {
        Container()
    }
}
