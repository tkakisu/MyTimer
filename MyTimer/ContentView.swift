//
//  ContentView.swift
//  MyTimer
//
//  Created by takahiro kakisu on 2025/08/16.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // グラデーション背景
                LinearGradient(
                    colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 50) {
                    Spacer()
                    
                    // プログレスリング付きタイマー表示
                    ZStack {
                        // 背景の円
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 8)
                            .frame(width: 250, height: 250)
                        
                        // プログレスリング
                        Circle()
                            .trim(from: 0, to: viewModel.progress)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.orange, Color.red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 250, height: 250)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1), value: viewModel.progress)
                        
                        // 中央のタイマー表示
                        VStack(spacing: 8) {
                            Text("\(viewModel.remainingTime)")
                                .font(.system(size: 60, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .contentTransition(.numericText(value: Double(viewModel.remainingTime)))
                                .animation(.easeInOut(duration: 0.3), value: viewModel.remainingTime)
                            
                            Text("秒")
                                .font(.title2)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    
                    Spacer()
                    
                    // ボタンエリア
                    HStack(spacing: 40) {
                        // スタート・一時停止ボタン
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                viewModel.startTimer()
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.green, Color.green.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                Image(systemName: viewModel.shouldShowPlayIcon ? "play.fill" : "pause.fill")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .scaleEffect(viewModel.isTimerRunning ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.isTimerRunning)
                        .disabled(viewModel.remainingTime == 0 && !viewModel.isTimerRunning && viewModel.count == 0)
                        
                        // ストップボタン
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                viewModel.stopTimer()
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.red, Color.red.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                Image(systemName: "stop.fill")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .opacity((viewModel.isTimerRunning || viewModel.count > 0) ? 1.0 : 0.6)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.isTimerRunning)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            // 画面が表示されるときに実行される
            .onAppear {
                // 経過時間を初期化
                viewModel.resetCount()
            }
            // ナビゲーションにボタンを追加
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // ナビゲーション遷移
                    NavigationLink {
                        SettingView()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "gear")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            // 状態変数showAlertがtrueになったときに実行される
            .alert("タイマー終了", isPresented: $viewModel.showAlert) {
                Button("OK") {
                    // OKをタップしたときにここが実行される
                    viewModel.resetCount()
                }
            } message: {
                Text("設定時間が経過しました")
            }
        }
    }
}

#Preview {
    ContentView()
}
