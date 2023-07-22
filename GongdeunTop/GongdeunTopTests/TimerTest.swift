//
//  TimerTest.swift
//  GongdeunTopTests
//
//  Created by Martin on 2023/07/22.
//

import XCTest
@testable import GongdeunTop

@MainActor
final class TimerTest: XCTestCase {
     func testIsBasicSetting() {
        let basicSessions = Session.getBasicSessions()
        let nonBasicSessions = Array(
            repeating: Session(concentrationSeconds: Int.random(in: 0..<50),
                               restSeconds: Int.random(in: 0..<50)),
            count: 6)
        let timerManager = TimerManager()
        XCTAssertEqual(timerManager.knowIsBasicSetting(basicSessions), true)
        XCTAssertEqual(timerManager.knowIsBasicSetting(nonBasicSessions), false)
    }
    
    
    func testCanNoticeChangeInSessions() {
        let timerManger = TimerManager()
        XCTAssertEqual(timerManger.isDefaultSessionsSetting, true)
        
        timerManger.timeSetting.sessions = Session.getRandomLooseSessions()
        XCTAssertEqual(timerManger.isDefaultSessionsSetting, false)
    }
}
