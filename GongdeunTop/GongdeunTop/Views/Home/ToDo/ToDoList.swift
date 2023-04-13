//
//  ToDoList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI


struct ToDoList: View {
    
    @StateObject var todoStore = ToDoStore()
    @StateObject var timerViewModel = TimerViewModel()
    
    @State private var isAddSheetOn: Bool = false
    @State private var isSetTimeViewOn: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ScrollView {
                    if todoStore.todos.isEmpty {
                        ToDoRow(todo: .placeholder)
                            .disabled(true)
                    } else {
                        ForEach(todoStore.todos, id: \.self) { todo in
                            ToDoRow(todo: todo)
                        }
                    }
                }
                .frame(height: geo.size.height * 0.84)
                
                Divider()
                
                
                VStack {
                    HAlignment(alignment: .center) {
                        Text("\(timerViewModel.numOfSessions)개 세션, 총 \(timerViewModel.getTotalTime())분")
                            .font(.caption)
                    }
                    
                    HStack {
                        Button {
                            isSetTimeViewOn.toggle()
                        } label: {
                            Text("시간 설정")
                                .frame(width: geo.size.width / 2 - 33, height: 36)
                        }
                        .sheet(isPresented: $isSetTimeViewOn) {
                            SetTimeForm(viewModel: timerViewModel)
                                .presentationDetents([.medium])
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                        
                        Spacer()
                        
                        NavigationLink {
                            GTtimer(timerViewModel: timerViewModel)
                        } label: {
                            Text("시작")
                                .frame(width: geo.size.width / 2 - 33, height: 36)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.pink)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("오늘 하루 할 일")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .onAppear {
            todoStore.subscribeTodos()
        }
        .onDisappear {
            todoStore.unsubscribeTodos()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isAddSheetOn = true
                } label: {
                    Label("추가하기", systemImage: "plus.circle.fill")
                }
                .sheet(isPresented: $isAddSheetOn) {
                    SetToDoForm()
                }
                .tint(.GTEnergeticOrange)
            }
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
