//
//  HomeView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI



struct HomeView: View {
    
    var body: some View {
        NavigationView {
          ToDoView()
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink("오늘 하루 시작하기") {
                            TimerView()
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
