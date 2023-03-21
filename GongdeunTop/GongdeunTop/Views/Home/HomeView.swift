//
//  HomeView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI



struct HomeView: View {
    @StateObject var timerViewModel = TimerViewModel()
    @StateObject var toDoViewModel = ToDoViewModel()
    
    
    var body: some View {
        NavigationView {
            ToDoView(viewModel: toDoViewModel)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            TimerView(timerViewModel: timerViewModel,
                                      toDoViewModel: toDoViewModel)
                        } label: {
                            Text("시작")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        SheetPresenter("", image: UIImage(systemName: "clock.badge.checkmark")) {
                            SetTimeView(viewModel: timerViewModel)
                                .frame(width: UIScreen.main.bounds.width)
                                .edgesIgnoringSafeArea(.bottom)
                                .background(.white)
                        }
                    }
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
