//
//  SessionsTimer.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct SessionsTimer: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage("lastTime") private var lastTimeObserved: String = ""
    
    @ObservedObject var timerManager: TimerManager
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
                
                SessionIndicator(viewModel: timerManager)
                    .frame(width: shorterSize * 0.5)
                
                Spacer()
                
                if !todoStore.todos.isEmpty {
                    Menu {
                        ForEach(todoStore.todos, id: \.self) { todo in
                            Button {
                                timerManager.currentTodo = todo
                            } label: {
                                Text(todo.title)
                            }
                        }
                    } label: {
                        Text(timerManager.currentTodo?.title ?? "현재 할 일 없음")
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
            if timerManager.timer == nil && isFirstCountDownEnded {
                handlePlayButton()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            guard timerManager.isRunning else { return }

            if newPhase == .active {
                // 저장되어있는 시점으로부터의 시간을 남아있는 시간에서 제한다.
                let last: Double = Double(lastTimeObserved) ?? 0.0
                let now: Double = Double(Date.now.timeIntervalSince1970)
                let diff: Int = Int((now - last).rounded())
                
                print("Time will be Subtracted \(diff)")

                timerManager.remainSeconds = (timerManager.knowIsRefreshTime() ? timerManager.refreshTime : timerManager.concentrationTime) * 60 - diff
            }
            
        }
        .onAppear {
            todoStore.subscribeTodos()
        }
        .onDisappear{
            todoStore.unsubscribeTodos()
        }
        .sheet(isPresented: $isShowingCycleMemoir) {
            timerManager.reset()
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
            Image(systemName: timerManager.isRunning ?  "pause.fill" : "play.fill")
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
            Text(timerManager.getMinute())
                .offset(x: -width * 0.1)
            Text(":")
                .offset(y: -8)
            Text(timerManager.getSecond())
                .offset(x: width * 0.1)
        }
        .font(.system(size: 54))
        .foregroundColor(.white)
        .padding(.bottom, 25)
    }
    
    @ViewBuilder
    private func getTimerBackground(width: CGFloat) -> some View {
        CircularSector(endDegree: timerManager.getEndDegree())
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
        if timerManager.isRunning {
            timerManager.timer?.invalidate()
        } else {
            recordStartingTime()
            
            timerManager.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timerManager.remainSeconds > 0 {
                    timerManager.remainSeconds -= 1
                    updateToDoTimeSpent()
                    
                } else {
                    timerManager.timer?.invalidate()
                    timerManager.isRunning = false
                    if timerManager.knowIsInSession() {
                        timerManager.currentSession += 1
                    }
                }
            }
        }
        timerManager.isRunning.toggle()
    }
    
    private func updateToDoTimeSpent() {
        guard !timerManager.knowIsRefreshTime() else { return }
        
        if let index = todoStore.todos.firstIndex(where: { $0.id == timerManager.currentTodo?.id }) {
            todoStore.todos[index].timeSpent += 1
        }
    }
    
    private func recordStartingTime() {
        // 초창기에만 기록하면 됨
        let isConcentrationTimeStarted: Bool = !timerManager.knowIsRefreshTime() && timerManager.remainSeconds == timerManager.concentrationTime * 60
        let isRefreshTimeStarted: Bool = timerManager.knowIsRefreshTime() && timerManager.remainSeconds == timerManager.refreshTime * 60
        
        guard isConcentrationTimeStarted || isRefreshTimeStarted else {
            print("Failed To Record Time \(timerManager.remainSeconds)")
            return
        }
        
        lastTimeObserved = String(Date.now.timeIntervalSince1970)
        print("Time is Recorded \(lastTimeObserved)")
    }
    
    private func handleResetButton() {
        timerManager.timer?.invalidate()
        timerManager.isRunning = false
        if timerManager.knowIsRefreshTime() {
            if timerManager.currentSession == timerManager.numOfSessions * 2 {
                timerManager.remainSeconds = 30 * 60
            } else {
                timerManager.remainSeconds = timerManager.refreshTime * 60
            }
        } else {
            timerManager.remainSeconds = timerManager.concentrationTime * 60
        }
    }
    
    private func handleNextButton() {
        withAnimation {
            timerManager.timer?.invalidate()
            timerManager.isRunning = false
            if timerManager.knowIsInSession() {
                timerManager.currentSession += 1
            }
        }
        
    }
    
    
}



struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsTimer(timerManager: TimerManager())
        
    }
}
