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
    
    
    @State private var isEditing: Bool = false
    @State private var multiSelection = Set<String?>()
    
    
    @State private var isAddSheetOn: Bool = false
    @State private var isSetTimeViewOn: Bool = false
    
    var body: some View {
        NavigationView{
            GeometryReader { geo in
                VStack {
                    List(todoStore.todos, selection: $multiSelection) { todo in
                        ToDoRow(todo: todo)
                    }
                    .frame(height: geo.size.height * (isEditing ? 0.89 : 0.84))
                    .listStyle(.plain)
                    .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                withAnimation {
                                    isEditing.toggle()     
                                }
                            } label: {
                                Text(isEditing ? "완료" : "수정")
                            }
                        }
                        
                        
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
                    
                    
                    Divider()
                    
                    if isEditing == false {
                        VStack {
                            HAlignment(alignment: .center) {
                                Text("\(todoStore.todos.count)개 할 일, \(timerViewModel.numOfSessions)개 세션, 총 \(timerViewModel.getTotalTime())분")
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
                            .padding(6)
                        }
                        .animation(.easeIn, value: isEditing)
                        
                    }
                    else {
                        HStack {
                            Button {
                                
                            } label: {
                                Text("삭제")
                            }
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Text("할 일 완료")
                            }
                            
                        }
                        .tint(.GTDenimNavy)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 6)
                        
                    }
                    
                    
                }
            }
            .navigationTitle("오늘 하루 할 일")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                todoStore.subscribeTodos()
            }
            .onDisappear {
                todoStore.unsubscribeTodos()
            }
        }
        
        
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
