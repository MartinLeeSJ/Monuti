//
//  SessionsTimer.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct SessionsTimer: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var timerViewModel: TimerManager
    @StateObject var todoStore = ToDoStore()
    
    @State private var isFirstCountDownEnded: Bool = false
    @State private var isShowingReallyQuitAlert: Bool = false
    @State private var isShowingCycleMemoir: Bool = false

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let shorterSize = min(width, height)
            VStack {
                Spacer()

                getTimerBackground(width: shorterSize)
                    .overlay {
                        VStack(alignment: .center) {
                            
                            getDigitTimes(width: shorterSize)
                            
                            getButtons(width: shorterSize)
                            
                        }
                    }
                
                SessionIndicator(viewModel: timerViewModel)
                    .frame(width: shorterSize * 0.5)
                
                Spacer()
                
                if !todoStore.todos.isEmpty {
                    Menu {
                        ForEach(todoStore.todos, id: \.self) { todo in
                            Button {
                                timerViewModel.currentTodo = todo
                            } label: {
                                Text(todo.title)
                            }
                        }
                    } label: {
                        Text(timerViewModel.currentTodo?.title ?? "현재 할 일 없음")
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
                        isShowingReallyQuitAlert = false
                        isShowingCycleMemoir = true
                    } label: {
                        Text("끝내기")
                    }
                } message: {
                    Text("정말로 끝내시겠습니까?")
                }
                
            }
        }
        .overlay {
            if !isFirstCountDownEnded {
                FirstCountdown(isEnded: $isFirstCountDownEnded)
            }
        }
        .onChange(of: isFirstCountDownEnded) { _ in
            if timerViewModel.timer == nil && isFirstCountDownEnded {
                handlePlayButton()
            }
        }
        .onAppear {
            todoStore.subscribeTodos()
        }
        .onDisappear{
            todoStore.unsubscribeTodos()
        }
        .sheet(isPresented: $isShowingCycleMemoir) {
            timerViewModel.reset()
            dismiss()
        } content: {
            NavigationView {
                CycleMemoir(manager: CycleManager(todos: todoStore.todos))
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
        .foregroundColor(.white)
        .padding(.bottom, 25)
    }
    
    @ViewBuilder
    private func getTimerBackground(width: CGFloat) -> some View {
        CircularSector(endDegree: timerViewModel.getEndDegree())
            .frame(width: width * 0.85, height: width * 0.85)
            .foregroundColor(.GTDenimBlue)
            .clipShape(CubeHexagon(radius: width * 0.425))
            .overlay {
                CubeHexagon(radius: width * 0.425)
                    .stroke(style: .init(lineWidth: 8, lineJoin: .round))
                    .foregroundColor(.white.opacity(0.2))
            }
            .overlay {
                ForEach(0..<60, id: \.self) { index in
                    Circle()
                        .fill(Color.GTDenimNavy)
                        .opacity(0.6)
                        .frame(width: index % 5 == 0 ? 8 : 4)
                        .offset(y: width * 0.4)
                        .rotationEffect(Angle(degrees: Double(360 * index / 60)))
                }
            }
            .background {
                CubeHexagon(radius: width * 0.425)
                    .fill(Color.GTPastelBlue)
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
        guard !timerViewModel.knowIsRefreshTime() else { return }
        
        if let index = todoStore.todos.firstIndex(where: { $0.id == timerViewModel.currentTodo?.id }) {
            todoStore.todos[index].timeSpent += 1
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
        SessionsTimer(timerViewModel: TimerManager())
        
    }
}
