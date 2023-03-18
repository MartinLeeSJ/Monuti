//
//  HomeView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI



struct HomeView: View {
    
    
    @State private var isSheetOn: Bool = false
    
    var body: some View {
        NavigationView {
            ToDoView()
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink {
                            TimerView()
                        } label: {
                            Text("오늘 하루 시작하기")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isSheetOn.toggle()
                        } label: {
                            Image(systemName: "gearshape")
                        }
                        .sheet(isPresented: $isSheetOn) {
                            SetTimeView()
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
