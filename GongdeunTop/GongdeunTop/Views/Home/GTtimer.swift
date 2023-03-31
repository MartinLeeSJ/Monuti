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
    
    @State private var isShowingReallyQuitAlert: Bool = false

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            VStack {
                Spacer()

                getCircleBackground(width: width)
                    .overlay {
                        VStack(alignment: .center) {
                            
                            getDigitTimes(width: width)
                            
                            getButtons(width: width)
                            
                        }
                    }
                
                SessionIndicator(viewModel: timerViewModel)
                    .frame(width: width * 0.5)
                
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
                    isShowingReallyQuitAlert = true
                    handlePlayButton()
                } label: {
                    Text("끝내기")
                }
                .alert("Will You Really Quit?",isPresented: $isShowingReallyQuitAlert) {
                    Button {
                        handlePlayButton()
                        isShowingReallyQuitAlert = false
                    } label: {
                        Text("계속하기")
                    }
                    
                    Button {
                        timerViewModel.reset()
                        dismiss()
                        isShowingReallyQuitAlert = false
                    } label: {
                        Text("끝내기")
                    }
                } message: {
                    Text("정말로 끝내시겠습니까?")
                }
                
            }
        }
        .overlay {
            if timerViewModel.timer == nil {
                FirstCountdown()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
                if timerViewModel.timer == nil {
                    handlePlayButton()
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
            .foregroundColor(.GTPastelBlue)
            .frame(width: width * 0.8, height: width * 0.8)
            .overlay {
                CircularSector(endDegree: timerViewModel.getEndDegree())
                    .foregroundColor(.GTDenimBlue)
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
            if timerViewModel.currentSession == timerViewModel.numOfSessions * 2 {
                timerViewModel.remainSeconds = 30 * 60
            } else {
                timerViewModel.remainSeconds = timerViewModel.refreshTime * 60
            }
        } else {
            timerViewModel.remainSeconds = timerViewModel.concentrationTime * 60
        }
    }
    
    private func handleNextButton() {
        withAnimation {
            timerViewModel.timer?.invalidate()
            timerViewModel.isRunning = false
            if timerViewModel.knowIsInSession() {
                timerViewModel.currentSession += 1
            }
        }
        
    }
    
    
}



struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        Home(timerViewModel: TimerViewModel(), toDoViewModel: ToDoViewModel())
        
    }
}
