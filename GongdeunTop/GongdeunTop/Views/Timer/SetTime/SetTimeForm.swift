//
//  SetTimeForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/18.
//

import SwiftUI
import Combine


struct SetTimeForm: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var manager: TimerSettingManager
    

    var body: some View {
        VStack {
            Picker("Mode", selection: $manager.mode) {
                ForEach(TimerSettingManager.TimeSetMode.allCases, id: \.id) { mode in
                    Text(mode.localizedStringKey)
                }
            }
            .pickerStyle(.segmented)

            switch manager.mode {
            case .batch: BatchTimeSettingForm(manager: manager)
            case .individual: IndividualTimeSettingForm(manager: manager)
//            case .preset: PresetTimeSettingForm()
            }
        }
        .padding(16)
    }
}


struct SetTimeView_Previews: PreviewProvider {
    struct Container: View {
        @StateObject var themeManger = ThemeManager()
        @ObservedObject var timerSettingManager = TimerSettingManager()
        
        var body: some View {
            SetTimeForm(manager: timerSettingManager)
                .environmentObject(themeManger)
        }
    }

    static var previews: some View {
        Container()
    }
}
