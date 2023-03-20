//
//  TimerView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var timerViewModel: TimerViewModel
    @ObservedObject var toDoViewModel: ToDoViewModel
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            VStack {
                Spacer()
                    .frame(height: height * 0.2)
                
                VStack(alignment: .center) {
                    
                    getDigitTimes(width: width)
                    
                    getButtons(width: width)
                    
                }
                .background {
                    getCircleBackground(width: width)
                }
                Spacer()
                
                if toDoViewModel.todos.isEmpty {
                    
                    
                } else {
                    
                    Menu {
                        ForEach(toDoViewModel.todos, id: \.self) { todo in
                            Button {
                                toDoViewModel.currentTodo = todo
                            } label: {
                                Text(todo.title)
                            }
                        }
                    } label: {
                        Text(toDoViewModel.currentTodo.title)
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
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
        .overlay {
            HStack {
                Button {
                    handleResetButton()
                } label: {
                    Image(systemName: "chevron.backward.to.line")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button {
                    handleNextButton()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: width * 0.45)
        }
    }
    
    @ViewBuilder
    private func getDigitTimes(width: CGFloat) -> some View {
        ZStack {
            Text(timerViewModel.getMinute())
                .offset(x: -width * 0.08)
            Text(":")
            Text(timerViewModel.getSecond())
                .offset(x: width * 0.08)
        }
        .font(.largeTitle.weight(.semibold))
        .padding(.bottom, 25)
    }
    
    @ViewBuilder
    private func getCircleBackground(width: CGFloat) -> some View {
        Circle()
            .foregroundColor(.GTyellowBright)
            .frame(width: width * 0.8, height: width * 0.8)
            .overlay {
                CircularSector(endDegree: timerViewModel.getEndDegree())
                    .foregroundColor(.GTyellow)
            }
    }
    
    
    private func handlePlayButton() {
        if timerViewModel.isRunning {
            timerViewModel.timer?.invalidate()
        } else {
            timerViewModel.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timerViewModel.remainSeconds > 0 {
                    timerViewModel.remainSeconds -= 1
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
        TimerView(timerViewModel: TimerViewModel(), toDoViewModel: ToDoViewModel())
    }
}
