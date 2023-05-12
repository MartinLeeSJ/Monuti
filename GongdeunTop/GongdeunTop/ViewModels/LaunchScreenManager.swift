//
//  LaunchScreenManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/12.
//

import Foundation

final class LaunchScreenManager: ObservableObject {
    enum LaunchScreenState {
        case launch, finished
    }
    
    @MainActor @Published private(set) var state: LaunchScreenState = .launch
    
    @MainActor
    func dismiss() {
        Task {
            try? await Task.sleep(for: Duration.seconds(1))     
            self.state = .finished
        }
    }
}
