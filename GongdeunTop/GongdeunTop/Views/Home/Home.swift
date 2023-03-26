//
//  Home.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI



struct Home: View {
    @ObservedObject var timerViewModel: TimerViewModel
    @ObservedObject var toDoViewModel: ToDoViewModel
    
    @State private var isSetTimeViewOn: Bool = false
    
    
    var body: some View {
        NavigationView {
            ToDoList(viewModel: toDoViewModel)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            GTTimer(timerViewModel: timerViewModel,
                                      toDoViewModel: toDoViewModel)
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
                            if #available(iOS 16.0, *) {
                                SetTimeForm(viewModel: timerViewModel)
                                    .presentationDetents([.medium])
                            } else {
                                SetTimeForm(viewModel: timerViewModel)
                            }
                        }
                    }
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Home(timerViewModel: TimerViewModel(), toDoViewModel: ToDoViewModel())
    }
}
