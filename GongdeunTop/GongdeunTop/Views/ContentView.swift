//
//  ContentView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct ContentView: View {
    @StateObject var timerViewModel = TimerViewModel()
    @StateObject var toDoViewModel = ToDoViewModel()
    
    @State private var tabSelection: Int8 = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Home(timerViewModel: timerViewModel, toDoViewModel: toDoViewModel)
            .tabItem {
                Label("하루", systemImage: "deskclock")
            }
            .tag(1)
            
            RecordView(toDoViewModel: toDoViewModel)
            .tabItem {
                Label("기록", systemImage: "text.redaction")
            }
            .tag(2)
        }
        .tint(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
