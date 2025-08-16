//
//  ContentViewTests.swift
//  MyTimerTests
//
//  Created by Claude on 2025/08/16.
//

import XCTest
import SwiftUI
@testable import MyTimer

final class TimerViewModelTests: XCTestCase {
    var viewModel: TimerViewModel!
    
    @MainActor
    override func setUp() {
        super.setUp()
        viewModel = TimerViewModel()
        viewModel.timerValue = 10 // テスト用に初期値を設定
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor
    func testInitialState() {
        // 初期状態のテスト
        XCTAssertEqual(viewModel.count, 0, "初期カウントは0であるべき")
        XCTAssertEqual(viewModel.remainingTime, 10, "初期残り時間は10であるべき")
        XCTAssertFalse(viewModel.showAlert, "初期状態ではアラートは表示されないべき")
        XCTAssertFalse(viewModel.isTimerRunning, "初期状態ではタイマーは動いていないべき")
        XCTAssertEqual(viewModel.progress, 0.0, accuracy: 0.01, "初期プログレスは0であるべき")
    }
    
    @MainActor
    func testRemainingTimeCalculation() {
        // 残り時間計算のテスト
        viewModel.count = 3
        XCTAssertEqual(viewModel.remainingTime, 7, "残り時間は7秒であるべき")
        
        viewModel.count = 10
        XCTAssertEqual(viewModel.remainingTime, 0, "残り時間は0秒であるべき")
        
        viewModel.count = 15
        XCTAssertEqual(viewModel.remainingTime, 0, "残り時間は負にならず0であるべき")
    }
    
    @MainActor
    func testProgressCalculation() {
        // プログレス計算のテスト
        viewModel.count = 0
        XCTAssertEqual(viewModel.progress, 0.0, accuracy: 0.01, "プログレスは0であるべき")
        
        viewModel.count = 5
        XCTAssertEqual(viewModel.progress, 0.5, accuracy: 0.01, "プログレスは0.5であるべき")
        
        viewModel.count = 10
        XCTAssertEqual(viewModel.progress, 1.0, accuracy: 0.01, "プログレスは1.0であるべき")
    }
    
    @MainActor
    func testResetCount() {
        // resetCountのテスト
        viewModel.count = 5
        viewModel.isPaused = true
        viewModel.resetCount()
        XCTAssertEqual(viewModel.count, 0, "resetCount後はカウントが0になるべき")
        XCTAssertFalse(viewModel.isPaused, "resetCount後は一時停止状態が解除されるべき")
    }
    
    @MainActor
    func testStopTimer() {
        // stopTimerのテスト
        viewModel.count = 5
        viewModel.stopTimer()
        XCTAssertEqual(viewModel.count, 0, "stopTimer後はカウントが0になるべき")
        XCTAssertFalse(viewModel.isTimerRunning, "stopTimer後はタイマーが停止しているべき")
    }
    
    @MainActor
    func testPauseTimer() {
        // pauseTimerのテスト
        viewModel.count = 3
        viewModel.pauseTimer()
        XCTAssertEqual(viewModel.count, 3, "pauseTimer後はカウントが保持されるべき")
        XCTAssertFalse(viewModel.isTimerRunning, "pauseTimer後はタイマーが停止しているべき")
        XCTAssertTrue(viewModel.isPaused, "pauseTimer後は一時停止状態になるべき")
        XCTAssertTrue(viewModel.shouldShowPlayIcon, "pauseTimer後はplayアイコンを表示するべき")
    }
    
    @MainActor
    func testStartTimerAfterPause() {
        // 一時停止後の再開テスト
        viewModel.count = 3
        viewModel.timerValue = 10
        
        // 一時停止
        viewModel.pauseTimer()
        XCTAssertEqual(viewModel.count, 3, "一時停止後はカウントが保持されるべき")
        XCTAssertFalse(viewModel.isTimerRunning, "一時停止後はタイマーが停止しているべき")
        
        // 再開
        viewModel.startTimer()
        XCTAssertEqual(viewModel.count, 3, "再開時はカウントが保持されるべき")
        XCTAssertTrue(viewModel.isTimerRunning, "再開後はタイマーが動作しているべき")
    }
    
    @MainActor
    func testStartTimerWhenFinished() {
        // タイマー終了後のリセット機能テスト
        viewModel.count = 10
        viewModel.timerValue = 10
        
        XCTAssertEqual(viewModel.remainingTime, 0, "残り時間は0であるべき")
        
        viewModel.startTimer()
        XCTAssertEqual(viewModel.count, 0, "タイマー終了後のスタートではカウントがリセットされるべき")
    }
}