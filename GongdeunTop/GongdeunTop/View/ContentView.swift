//
//  ContentView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection: Int8 = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            HomeView().tabItem { Text("하루") }.tag(1)
            RecordView().tabItem { Text("기록") }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
