//
//  SetTimeGraph.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/20.
//

import SwiftUI

struct SetTimeGraph: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var manager: TimerSettingManager
    @Binding var currentFocusedIndex: Int
    
    init(manager: TimerSettingManager, currentFocusedIndex: Binding<Int>? = nil) {
        self.manager = manager
        self._currentFocusedIndex = currentFocusedIndex ?? .constant(-1)
    }
    var body: some View {
        VStack {
            header
            drawGraph()
        }
    }
}

// MARK: - Total Time Header
extension SetTimeGraph {
    var totalSeconds: Int { manager.getTotalSeconds() }
    var header: some View {
        Text("totalTime\(manager.getMinute(of: totalSeconds))\(manager.getSeconds(of: totalSeconds))")
            .font(.title)
            .bold()
    }
}

// MARK: - Time Setting Graph
extension SetTimeGraph {
    private func goToTappedSession(ofIndex index: Int) {
        guard manager.mode == .individual else { return }
        withAnimation {
            currentFocusedIndex = index
        }
    }
    
    private func concentrationTimeRatio(ofSession index: Int) -> CGFloat {
        guard let session = manager.timeSetting.sessions[safe: index] else {
            print("out of index")
            return CGFloat(1)
        }
        let concetrationSeconds = CGFloat(session.concentrationSeconds)
        let totalSeconds = CGFloat(manager.getTotalSeconds())
        return concetrationSeconds / totalSeconds
    }
    
    private func restTimeRatio(ofSession index: Int) -> CGFloat {
        guard let session = manager.timeSetting.sessions[safe: index] else {
            print("out of index")
            return CGFloat(1)
        }
        let restSeconds = CGFloat(session.restSeconds)
        let totalSeconds = CGFloat(manager.getTotalSeconds())
        return restSeconds / totalSeconds
    }
    
    @ViewBuilder
    func drawGraph() -> some View {
        GeometryReader { geo in
            let width = geo.size.width
            HStack(spacing: 0) {
                ForEach(manager.timeSetting.sessions.indices, id: \.self) { index in
                    var sessionRatio: CGFloat {
                        concentrationTimeRatio(ofSession: index) + restTimeRatio(ofSession: index)
                    }
                    var sessionWidth: CGFloat {
                        width * sessionRatio
                    }
                    
                    var concentrationTimeWidth: CGFloat {
                        let newWidth = width * concentrationTimeRatio(ofSession: index) - 4
                        return newWidth > 0 ? newWidth : 0
                    }
                    
                    var restTimeWidth: CGFloat {
                        let newWidth = width * restTimeRatio(ofSession: index) - 4
                        return newWidth > 0 ? newWidth : 0
                    }
                    
                    HStack(spacing: 2) {
                        Rectangle()
                            .foregroundColor(themeManager.colorInPriority(of: .solid))
                            .frame(width: concentrationTimeWidth,
                                   height: 48)
                        
                        Rectangle()
                            .foregroundColor(themeManager.colorInPriority(of: .medium))
                            .frame(width: restTimeWidth < 0 ? 0 : restTimeWidth,
                                   height: 48)
                    }
                    .padding(.horizontal, 5)
                    .frame(width: sessionWidth)
                    .overlay(alignment: .bottom) {
                        Capsule()
                            .frame(width: sessionWidth - 10, height: 5)
                            .foregroundColor(index == currentFocusedIndex ? Color("basicFontColor") : .gray)
                            .opacity(0.5)
                            .offset(y: 10)
                    }
                    .onTapGesture {
                        goToTappedSession(ofIndex: index)
                    }
                }
            }
            .frame(width: width)
            
        }
        .frame( height: 58)
    }
}


