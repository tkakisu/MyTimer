//
//  SettingView.swift
//  MyTimer
//
//  Created by takahiro kakisu on 2025/08/16.
//

import SwiftUI

struct SettingView: View {
    // 永続化する秒数設定
    @AppStorage("timer_value") var timerValue = 10
    
    private let timeOptions = [10, 20, 30, 40, 50, 60, 90, 120, 180, 300]
    
    var body: some View {
        ZStack {
            // グラデーション背景
            LinearGradient(
                colors: [Color.indigo.opacity(0.8), Color.blue.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // ヘッダー
                VStack(spacing: 16) {
                    Image(systemName: "timer")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    
                    Text("タイマー設定")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // 現在の設定値表示
                VStack(spacing: 12) {
                    Text("設定時間")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Text("\(timerValue)秒")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText(value: Double(timerValue)))
                        .animation(.easeInOut(duration: 0.3), value: timerValue)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 40)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.2))
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                )
                
                Spacer()
                
                // Pickerを表示
                VStack(spacing: 20) {
                    Text("時間を選択")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Picker(selection: $timerValue) {
                        ForEach(timeOptions, id: \.self) { time in
                            Text("\(time)秒")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .tag(time)
                        }
                    } label: {
                        Text("選択")
                    }
                    .pickerStyle(.wheel)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white.opacity(0.1))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // 説明テキスト
                Text("スクロールして時間を選択してください")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("")
            }
        }
    }
}

#Preview {
    SettingView()
}
