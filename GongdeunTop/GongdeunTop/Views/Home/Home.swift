//
//  Home.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI



struct Home: View {
    @StateObject var timerViewModel = TimerViewModel()
   
    
    @State private var isSetTimeViewOn: Bool = false
    
    
    var body: some View {
        NavigationView {
            ToDoList()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            GTtimer(timerViewModel: timerViewModel)
                        } label: {
                            Text("시작")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isSetTimeViewOn.toggle()
                        } label: {
                            Text("시간설정")
                        }
                        .sheet(isPresented: $isSetTimeViewOn) {
                            SetTimeForm(viewModel: timerViewModel)
                                .presentationDetents([.medium])
                        }
                    }
                }
        }
        .toolbar(.visible, for: .tabBar)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
