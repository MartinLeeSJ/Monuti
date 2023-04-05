//
//  Home.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI



struct Home: View {
    @StateObject var timerViewModel = TimerViewModel()
    @StateObject var toDosViewModel = ToDosViewModel()
    
    @State private var isSetTimeViewOn: Bool = false
    
    
    var body: some View {
        NavigationView {
            ToDoList(todos: toDosViewModel.todos)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            GTtimer(timerViewModel: timerViewModel,
                                    todos: toDosViewModel.todos)
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
        .toolbar(.visible, for: .tabBar)
        .onAppear {
            toDosViewModel.subscribeTodos()
        }
        .onDisappear {
            toDosViewModel.unsubscribeTodos()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
