//
//  IndividualTimeSettingForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/10.
//

import SwiftUI

struct IndividualTimeSettingForm: View  {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var manager: TimerManager
   

    var body: some View {
        VStack(spacing: 4) {}
        
    }
    

}



struct IndividualTimeSettingForm_Previews: PreviewProvider {
    static var previews: some View {
        IndividualTimeSettingForm(manager: TimerManager())
            .environmentObject(ThemeManager())
    }
}
