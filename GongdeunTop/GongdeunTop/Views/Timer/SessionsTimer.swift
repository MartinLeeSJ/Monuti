//
//  SessionsTimer.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI
import UserNotifications

struct SessionsTimer: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var timerManager = TimerManager(timeSetting: TimeSetting())
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var appBlockManager: AppBlockManager
    
    @AppStorage("lastTime") private var lastTimeObserved: TimeInterval = 0
    
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
//            let digitTimeWidth = shorterSize * 0.5
            
            VStack {
                Spacer()
                TimerHexagon(width: shorterSize,
                             timerEndDegree: timerManager.getEndDegree(),
                             foregroundColor: themeManager.colorInPriority(of: .medium),
                             backgroundColor: themeManager.colorInPriority(of: .weak))
                    .overlay {
                        VStack {
                            timerDigit()
                            
                            timerControls(width: shorterSize)
                        }
                    }
                    .padding(.bottom, 20)
                
                sessionIndicator(width: indicatorWidth)
                
                Spacer()
                
                if !todos.isEmpty {
                    todoMenu()
                }
                Spacer()
            }
            .frame(width: width, height: height)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            toolbarContents()
        }
        .sheet(isPresented: $isShowingCycleMemoir) {
            timerManager.resetToOrigin()
            dismiss()
        } content: {
            NavigationStack {
                CycleMemoir(manager: CycleManager(todos: todos))
            }
        }
        .overlay {
            if !isFirstCountDownEnded {
                FirstCountdown(isEnded: $isFirstCountDownEnded)
            }
        }
        .onChange(of: isFirstCountDownEnded) { _ in
            if !timerManager.isRunning && isFirstCountDownEnded {
                handlePlay()
            }
        }
        .onChange(of: scenePhase) { [oldPhase = scenePhase] newPhase in
            manageTimeWithScenePhase(old: oldPhase, new: newPhase)
        }
        .onReceive(timerManager.timer) { _ in
            if timerManager.isRunning {
                if timerManager.remainSeconds > 0 {
                    timerManager.elapsesTime()
                    updateToDoTimeSpentWhenTimerTicks()
                } else {
                    timerManager.moveToNextTimes()
                }
            }
        }
    }
}


// MARK: - Timer UI
extension SessionsTimer {
    private func timerDigit() -> some View {
        Text(timerManager.remainSeconds.sessionTimerDigit)
            .font(.system(size: 60, weight: .regular))
            .kerning(3)
            .monospacedDigit()
            .foregroundColor(themeManager.timerDigitAndButtonColor())
            .padding(.bottom, 25)
    }
    
    
    @ViewBuilder
    private func timerControls(width: CGFloat) -> some View {
        Button {
            handlePlay()
        } label: {
            Image(systemName: timerManager.isRunning ?  "pause.fill" : "play.fill")
                .font(.largeTitle)
        }
        .overlay {
            HStack {
                Button {
                    handleReset()
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title)
                }
                Spacer()
                Button {
                    handleNext()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.largeTitle)
                }
            }
            .frame(width: width * 0.45)
        }
        .foregroundColor(themeManager.timerDigitAndButtonColor())
        .frame(height: 30)
    }
}

// MARK: - Indicator UI
extension SessionsTimer {
    @ViewBuilder
    func sessionIndicator(width: CGFloat) -> some View {
        SessionIndicator(manager: timerManager)
            .frame(width: width)
            .gesture(DragGesture(minimumDistance: 2.0, coordinateSpace: .local)
                .onEnded { value in
                    let swipeLeftRange: PartialRangeThrough<CGFloat> = ...0
                    let swipeRightRange: PartialRangeFrom<CGFloat> = 0...
                    let verticalSwipeConstraint: ClosedRange<CGFloat> = -50...50
                    
                    switch(value.translation.width, value.translation.height) {
                    case (swipeLeftRange, verticalSwipeConstraint):
                        handleNext()
                    case (swipeRightRange, verticalSwipeConstraint):
                        handleReset()
                    default:  print("no clue")
                    }
            })
    }
}

// MARK: - TodoMenu UI
extension SessionsTimer {
    @ViewBuilder
    private func todoMenu() -> some View {
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
            .foregroundColor(themeManager.colorInPriority(of: .accent))
            .disabled(todos.isEmpty)
        }
    }
}

// MARK: - Button Methods
extension SessionsTimer {
    private func handlePlay() {
        if timerManager.isRunning {
            timerManager.pauseTime()
            appBlockManager.stopConcentrationAppShield()
        } else {
            timerManager.startTime()
            appBlockManager.startConcentrationAppShield()
        }
    }
    
    private func handleReset() {
        timerManager.resetTimes()
    }
    
    private func handleNext() {
        timerManager.moveToNextTimes()
    }
    
    private func handleQuit() {
        if !timerManager.knowIsLastTime() {
            isShowingReallyQuitAlert = true
        } else {
            isShowingCycleMemoir = true
        }
        handlePlay()
    }
}

// MARK: - Manage Times
extension SessionsTimer {
    private func manageTimeWithScenePhase(old oldPhase: ScenePhase, new newPhase: ScenePhase) {
        guard timerManager.isRunning else { return }
        switch (newPhase, oldPhase) {
        case (.inactive, .background): manageTimeWhenWakeApp()
        case (.background, _): manageTimeWithBackgroundMode()
        case (.inactive, .active): print("active => inactive")
        case (.active, _): print("active")
        default: print("default")
        }
    }
    
    private func manageTimeWithBackgroundMode() {
        recordTime()
        scheduleUserNotification()
    }
    
    private func manageTimeWhenWakeApp() {
        let timeElapsed = timerManager.subtractTimeElapsed(from: lastTimeObserved)
        updateToDoTimeSpentWhenWakeApp(timeElapsed: timeElapsed)
        if !timerManager.isRunning {
            appBlockManager.stopConcentrationAppShield()
        }
    }
    
    private func updateToDoTimeSpentWhenTimerTicks() {
        guard !timerManager.knowIsInRestTime() else { return }
        
        if let index = todos.firstIndex(where: { $0.id == currentTodo?.id }) {
            todos[index].timeSpent += 1
        }
    }
    
    private func updateToDoTimeSpentWhenWakeApp(timeElapsed: TimeInterval) {
        // 만약 지금이 쉬는시간일 때엔 남은시간이 설정된 쉬는시간과 같을 때에만 기록
        guard !timerManager.knowIsInRestTime() || timerManager.knowIsStartingPointOfThisTime() else { return }
        
        if let index = todos.firstIndex(where: { $0.id == currentTodo?.id }) {
            todos[index].timeSpent += Int(timeElapsed)
            print(todos[index].timeSpent)
        }
    }
    

    private func recordTime() {
        lastTimeObserved = Date.now.timeIntervalSince1970
    }
    
    private func scheduleUserNotification() {
        guard timerManager.isRunning else { return }
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        var notificationBody: String = ""
        
        switch (timerManager.knowIsInRestTime(), timerManager.knowIsLastTime()) {
        case (true, false): notificationBody = String(localized: "notification_restTime_ended")
        case (true, true): notificationBody = String(localized: "notification_allTime_ended")
        case (false, _): notificationBody = String(localized: "notification_concentrationTime_ended")
        default: notificationBody = ""
        }
        content.title = String(localized: "Monuti")
        content.body = notificationBody

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timerManager.remainSeconds, repeats: false)

        let req = UNNotificationRequest(identifier:  UUID().uuidString, content: content, trigger: trigger)

        notificationCenter.add(req) { error in
            if let error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Toolbars
extension SessionsTimer {
    @ToolbarContentBuilder
    func toolbarContents() -> some ToolbarContent {
        ToolbarItem {
            Button {
                handleQuit()
            } label: {
                Text(String(localized: "Quit"))
            }
            .alert(String(localized: "Quit") ,isPresented: $isShowingReallyQuitAlert) {
                Button {
                    handlePlay()
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

