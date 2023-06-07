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
    
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var timerManager: TimerManager
    
    @AppStorage("lastTime") private var lastTimeObserved: String = ""
    
 
    
    @State var todos: [ToDo] = []
    @State var currentTodo: ToDo? = nil
    
    @State private var isFirstCountDownEnded: Bool = false
    @State private var isShowingReallyQuitAlert: Bool = false
    @State private var isShowingCycleMemoir: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let shorterSize = min(width, height)
            let indicatorWidth = shorterSize * 0.45
            let digitTimeWidth = shorterSize * 0.5
            
            VStack {
                Spacer()
   
                getTimerShape(width: shorterSize)
                    .overlay {
                        VStack {
                            getDigitTimes(width: digitTimeWidth)
                            
                            getButtons(width: shorterSize)
                        }
                    }
                    .padding(.bottom, 20)
                
                getIndicator(width: indicatorWidth)
                
                Spacer()
                
                if !todos.isEmpty {
                    getTodoMenu()
                }
                
                
                Spacer()
            }
            .frame(width: width, height: height)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            toolbarContents()
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
        .onChange(of: scenePhase) { phase in
            updateTimeElapsed(newPhase: phase)
        }
        .sheet(isPresented: $isShowingCycleMemoir) {
            timerManager.resetToOrigin()
            dismiss()
        } content: {
            NavigationStack {
                CycleMemoir(manager: CycleManager(todos: todos), timerManager: timerManager)
            }
        }
    }
    
}


// MARK: - Timer UI
extension SessionsTimer {
    @ViewBuilder
    private func getButtons(width: CGFloat) -> some View {
        Button {
            handlePlayButton()
        } label: {
            Image(systemName: timerManager.isRunning ?  "pause.fill" : "play.fill")
                .foregroundColor(themeManager.getColorInPriority(of: .accent))
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
            .foregroundColor(themeManager.getColorInPriority(of: .accent))
            .frame(width: width * 0.45)
        }
        .frame(height: 30)
    }
    
    @ViewBuilder
    private func getDigitTimes(width: CGFloat) -> some View {
        let minuteWidth = width * 0.425
        let secondWidth = width * 0.425
        let colonWidth = width * 0.15
        HStack(alignment: .center, spacing: 0) {
            Text(timerManager.getMinute())
                .frame(width: minuteWidth, alignment: .trailing)
                .font(.system(size: 60, weight: .regular, design: .rounded))
            Text(":")
                .frame(width: colonWidth, alignment: .center)
                .font(.system(size: 54, weight: .regular))
            Text(timerManager.getSecond())
                .frame(width: secondWidth, alignment: .leading)
                .font(.system(size: 60, weight: .regular, design: .rounded))
        }
        
        .foregroundColor(themeManager.getColorInPriority(of: .accent))
        .padding(.bottom, 25)
    }
    
    @ViewBuilder
    private func getTimerShape(width: CGFloat) -> some View {
        CircularSector(endDegree: timerManager.getEndDegree())
            .frame(width: width * 0.85, height: width * 0.85)
            .foregroundColor(themeManager.getColorInPriority(of: .medium))
            .clipShape(RoundedHexagon(radius: width * 0.425, cornerAngle: 5))
            .overlay {
                CubeHexagon(radius: width * 0.425)
                    .stroke(style: .init(lineWidth: 8, lineJoin: .round))
                    .foregroundColor(.white.opacity(0.2))
            }
            .background {
                RoundedHexagon(radius: width * 0.425, cornerAngle: 5)
                    .foregroundColor(themeManager.getColorInPriority(of: .weak))
            }
        
    }
}

// MARK: - Indicator UI
extension SessionsTimer {
    @ViewBuilder
    func getIndicator(width: CGFloat) -> some View {
        SessionIndicator(manager: timerManager)
            .frame(width: width)
            .gesture(DragGesture(minimumDistance: 2.0, coordinateSpace: .local)
                .onEnded { value in
                    let swipeLeftRange: PartialRangeThrough<CGFloat> = ...0
                    let swipeRightRange: PartialRangeFrom<CGFloat> = 0...
                    let verticalSwipeConstraint: ClosedRange<CGFloat> = -50...50
                    
                    switch(value.translation.width, value.translation.height) {
                    case (swipeLeftRange, verticalSwipeConstraint):
                        handleNextButton()
                    case (swipeRightRange, verticalSwipeConstraint):
                        handleResetButton()
                    default:  print("no clue")
                    }
            })
    }
}

// MARK: - TodoMenu UI
extension SessionsTimer {
    @ViewBuilder
    private func getTodoMenu() -> some View {
        VStack {
            Text(currentTodo?.title ?? String(localized: "timer_currentTodo_nothing"))
                .font(.headline)
            
            Menu {
                ForEach(todos, id: \.self) { todo in
                    Button {
                        currentTodo = todo
                    } label: {
                        Text(todo.title)
                    }
                }
                
                Button {
                    currentTodo = nil
                } label: {
                    Text("timer_todoMenu_doNotSelect")
                }
            } label: {
                Label {
                    Text(String(localized: !todos.isEmpty ?
                                "timer_todoMenu" :
                                    "timer_todoMenu_nothing"))
                } icon: {
                    Image(systemName: "chevron.down")
                }
                .foregroundColor(.white)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 5)
                }
            }
            .menuStyle(.borderlessButton)
            .foregroundColor(themeManager.getColorInPriority(of: .accent))
            .disabled(todos.isEmpty)
        }
    }
}

// MARK: - Button Methods
extension SessionsTimer {
    private func handlePlayButton() {
        if timerManager.isRunning {
            timerManager.pauseTime()
        } else {
            recordStartingTime()
            
            timerManager.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timerManager.remainSeconds > 0 {
                    timerManager.elapsesTime()
                    updateToDoTimeSpent()
                } else {
                    timerManager.moveToNextTimes()
                }
            }
            
            timerManager.isRunning = true
        }
    }
    
    
    private func handleResetButton() {
        timerManager.resetTimes()
    }
    
    private func handleNextButton() {
        timerManager.moveToNextTimes()
    }
}

// MARK: - Record Times
extension SessionsTimer {
    private func updateToDoTimeSpent() {
        guard !timerManager.knowIsRefreshTime() else { return }
        
        if let index = todos.firstIndex(where: { $0.id == currentTodo?.id }) {
            todos[index].timeSpent += 1
        }
    }
    
    private func updateTimeElapsed(newPhase: ScenePhase) {
        guard timerManager.isRunning else { return }
        
        if newPhase == .active {
            let last: Double = Double(lastTimeObserved) ?? 0.0
            
            timerManager.subtractTimeElapsed(from: last)
        }
    }
    
    private func recordStartingTime() {
        // 초창기에만 기록하면 됨
        let isConcentrationTimeStarted: Bool = !timerManager.knowIsRefreshTime() && timerManager.remainSeconds == timerManager.timeSetting.concentrationTime * 60
        let isRefreshTimeStarted: Bool = timerManager.knowIsRefreshTime() && timerManager.remainSeconds == timerManager.timeSetting.refreshTime * 60
        
        guard isConcentrationTimeStarted || isRefreshTimeStarted else {
            print("Failed To Record Time \(timerManager.remainSeconds)")
            return
        }
        
        lastTimeObserved = String(Date.now.timeIntervalSince1970)
        print("Time is Recorded \(lastTimeObserved)")
    }
}

// MARK: - Toolbars
extension SessionsTimer {
    private func handleQuitButton() {
        if !timerManager.knowIsLastTime() {
            isShowingReallyQuitAlert = true
        } else {
            isShowingCycleMemoir = true
        }
        
        handlePlayButton()
    }
    
    @ToolbarContentBuilder
    func toolbarContents() -> some ToolbarContent {
        ToolbarItem {
            Button {
                handleQuitButton()
            } label: {
                Text(String(localized: "Quit"))
            }
            .alert(String(localized: "Quit") ,isPresented: $isShowingReallyQuitAlert) {
                Button {
                    handlePlayButton()
                    isShowingReallyQuitAlert = false
                } label: {
                    Text(String(localized:"Continue"))
                }
                
                Button {
                    isShowingReallyQuitAlert = false
                    isShowingCycleMemoir = true
                } label: {
                    Text(String(localized: "Quit"))
                }
            } message: {
                Text(String(localized: "really exit"))
            }
            
        }
    }
}

