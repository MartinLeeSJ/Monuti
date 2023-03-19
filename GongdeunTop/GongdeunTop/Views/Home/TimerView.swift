//
//  TimerView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TimerViewModel
    
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
            Image(systemName: viewModel.isRunning ?  "pause.fill" : "play.fill")
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
            Text(viewModel.getMinute())
                .offset(x: -width * 0.08)
            Text(":")
            Text(viewModel.getSecond())
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
                CircularSector(endDegree: viewModel.getEndDegree())
                    .foregroundColor(.GTyellow)
            }
    }
    
    
    private func handlePlayButton() {
        if viewModel.isRunning {
            viewModel.timer?.invalidate()
        } else {
            viewModel.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if viewModel.remainSeconds > 0 {
                    viewModel.remainSeconds -= 1
                } else {
                    viewModel.timer?.invalidate()
                    viewModel.isRunning = false
                    if viewModel.knowIsInSession() {
                        viewModel.currentSession += 1
                    }
                    
                }
            }
        }
        viewModel.isRunning.toggle()
    }
    private func handleResetButton() {
        viewModel.timer?.invalidate()
        viewModel.isRunning = false
        if viewModel.knowIsRefreshTime() {
            viewModel.remainSeconds = viewModel.refreshTime * 60
        } else {
            viewModel.remainSeconds = viewModel.concentrationTime * 60
        }
    }
    private func handleNextButton() {
        viewModel.timer?.invalidate()
        viewModel.isRunning = false
        if viewModel.knowIsInSession() {
            viewModel.currentSession += 1
        }
    }
}



struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(viewModel: TimerViewModel())
    }
}
