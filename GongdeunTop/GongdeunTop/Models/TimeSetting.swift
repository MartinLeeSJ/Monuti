//
//  TimeSetting.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/20.
//

import Foundation

struct TimeSetting {
    var session: Session = Session.getBasicSession()
    var sessions: [Session] = Session.getBasicSessions()
    var willGetLongRefresh: Bool = true
    var numOfSessions: Int {
        get { sessions.count }
        set(newValue) {
            guard abs(newValue - numOfSessions) == 1 else {
                return
            }
            if newValue < numOfSessions {
                sessions.removeFirst()
            } else {
                sessions.insert(self.session, at: sessions.startIndex)
            }
        }
    }
    static let longRefreshSeconds: Int = 30 * 60
}
