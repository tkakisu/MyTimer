//
//  TimerViewModel.swift
//  MyTimer
//
//  Created by Claude on 2025/08/16.
//

import Foundation
import SwiftUI

@MainActor
class TimerViewModel: ObservableObject {
    @Published var count = 0
    @Published var showAlert = false
    @Published var isPaused = false
    @AppStorage("timer_value") var timerValue = 10
    
    private var timerHandler: Timer?
    
    var remainingTime: Int {
        max(0, timerValue - count)
    }
    
    var isTimerRunning: Bool {
        timerHandler?.isValid == true
    }
    
    var progress: Double {
        guard timerValue > 0 else { return 0 }
        return Double(count) / Double(timerValue)
    }
    
    func startTimer() {
        // すでにタイマーが動いている場合は一時停止
        if let timerHandler = timerHandler, timerHandler.isValid {
            pauseTimer()
            return
        }
        
        // 残り時間が0以下の場合はリセット
        if remainingTime <= 0 {
            count = 0
        }
        
        isPaused = false
        
        // タイマーを開始
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            Task { @MainActor in
                self.countDownTimer()
            }
        }
    }
    
    func pauseTimer() {
        // タイマーを一時停止（カウントはそのまま保持）
        if let timerHandler = timerHandler, timerHandler.isValid {
            timerHandler.invalidate()
        }
        isPaused = true
    }
    
    func stopTimer() {
        // タイマーを停止してリセット
        if let timerHandler = timerHandler, timerHandler.isValid {
            timerHandler.invalidate()
        }
        count = 0
        isPaused = false
    }
    
    func resetCount() {
        count = 0
        isPaused = false
    }
    
    var shouldShowPlayIcon: Bool {
        !isTimerRunning
    }
    
    private func countDownTimer() {
        count += 1
        
        if timerValue - count <= 0 {
            timerHandler?.invalidate()
            showAlert = true
        }
    }
}