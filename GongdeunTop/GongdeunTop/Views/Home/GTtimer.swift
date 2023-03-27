//
//  GTtimer.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct GTtimer: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var timerViewModel: TimerViewModel
    @ObservedObject var toDoViewModel: ToDoViewModel
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            VStack {
                Spacer()
                    .frame(height: height * 0.15)
                
                Text("\(toDoViewModel.todos.first?.timeSpent ?? 0)")
                
                getCircleBackground(width: width)
                    .overlay {
                        VStack(alignment: .center) {
                            
                            getDigitTimes(width: width)
                            
                            getButtons(width: width)
                            
                        }
                    }
                
                Spacer()
                
                if !toDoViewModel.todos.isEmpty {
                    Menu {
                        ForEach(toDoViewModel.todos, id: \.self) { todo in
                            Button {
                                toDoViewModel.currentTodo = todo
                            } label: {
                                Text(todo.title)
                            }
                        }
                    } label: {
                        Text(toDoViewModel.currentTodo?.title ?? "현재 할 일 없음")
                    }
                }

                Spacer()
            }
            .frame(width: width, height: height)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem {
                Button {
                    dismiss()
                } label: {
                    Text("끝내기")
                }
                
            }
        }
    }
    
    
    @ViewBuilder
    private func getButtons(width: CGFloat) -> some View {
        Button {
            handlePlayButton()
        } label: {
            Image(systemName: timerViewModel.isRunning ?  "pause.fill" : "play.fill")
                .foregroundColor(.GTDenimNavy)
                .font(.largeTitle)
                
        }
        .overlay {
            HStack {
                Button {
                    handleResetButton()
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title)
                        
                }
                Spacer()
                Button {
                    handleNextButton()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.largeTitle)
                        
                }
            }
            .foregroundColor(.GTDenimNavy)
            .frame(width: width * 0.45)
        }
        .frame(height: 30)
    }
    
    @ViewBuilder
    private func getDigitTimes(width: CGFloat) -> some View {
        ZStack {
            Text(timerViewModel.getMinute())
                .offset(x: -width * 0.1)
            Text(":")
                .offset(y: -8)
            Text(timerViewModel.getSecond())
                .offset(x: width * 0.1)
        }
        .font(.system(size: 54))
        .padding(.bottom, 25)
    }
    
    @ViewBuilder
    private func getCircleBackground(width: CGFloat) -> some View {
        Circle()
            .foregroundColor(.GTyellowBright)
            .frame(width: width * 0.8, height: width * 0.8)
            .overlay {
                CircularSector(endDegree: timerViewModel.getEndDegree())
                    .foregroundColor(.GTPastelBlue)
            }
            .overlay {
                Rectangle()
                    .frame(width: 10, height: 20)
                    .offset(y: -width * 0.4)
                    .rotationEffect(Angle(degrees: -90))
            }
    }
    
    
    private func handlePlayButton() {
        if timerViewModel.isRunning {
            timerViewModel.timer?.invalidate()
        } else {
            timerViewModel.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timerViewModel.remainSeconds > 0 {
                    timerViewModel.remainSeconds -= 1
                    updateToDoTimeSpent()
                    
                } else {
                    timerViewModel.timer?.invalidate()
                    timerViewModel.isRunning = false
                    if timerViewModel.knowIsInSession() {
                        timerViewModel.currentSession += 1
                    }
                }
            }
        }
        timerViewModel.isRunning.toggle()
    }
    
    private func updateToDoTimeSpent() {
        if var updatingToDo = toDoViewModel.todos.first(where: { $0.id == toDoViewModel.currentTodo?.id }) {
            updatingToDo.timeSpent += 1
        }
    }
    
    private func handleResetButton() {
        timerViewModel.timer?.invalidate()
        timerViewModel.isRunning = false
        if timerViewModel.knowIsRefreshTime() {
            timerViewModel.remainSeconds = timerViewModel.refreshTime * 60
        } else {
            timerViewModel.remainSeconds = timerViewModel.concentrationTime * 60
        }
    }
    
    private func handleNextButton() {
        timerViewModel.timer?.invalidate()
        timerViewModel.isRunning = false
        if timerViewModel.knowIsInSession() {
            timerViewModel.currentSession += 1
        }
    }
    
    
}



struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        Home(timerViewModel: TimerViewModel(), toDoViewModel: ToDoViewModel())
        
    }
}
