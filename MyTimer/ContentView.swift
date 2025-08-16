//
//  ContentView.swift
//  MyTimer
//
//  Created by takahiro kakisu on 2025/08/16.
//

import SwiftUI

struct ContentView: View {
    // タイマー
    @State var timerHandler: Timer?
    // カウント（経過時間）
    @State var count = 0
    // 永続化する秒数設定（初期値は10）
    @AppStorage("timer_value") var timerValue = 10
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景画像
                Image(.backgroundTimer)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                
                VStack(spacing: 30.0) {
                    // テキストを表示する
                    Text("残り\(timerValue - count)秒")
                        .font(.largeTitle)

                    HStack {
                        // スタートボタン
                        Button {
                            // ボタンをタップしたときのアクション
                            startTimer()
                        } label: {
                            Text("スタート")
                                .font(.title)
                                .foregroundStyle(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color.start)
                                .clipShape(Circle())
                        }
                        
                        // ストップボタン
                        Button {
                            // ボタンをタップしたときのアクション
                            // timerHandlerをアンラップ
                            if let timerHandler {
                                // もしタイマーが実行中だったら停止
                                if timerHandler.isValid {
                                    timerHandler.invalidate()
                                }
                            }
                        } label: {
                            Text("ストップ")
                                .font(.title)
                                .foregroundStyle(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color.stop)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            // 画面が表示されるときに実行される
            .onAppear {
                // 経過時間を初期化
                count = 0
            }
            // ナビゲーションにボタンを追加
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // ナビゲーション遷移
                    NavigationLink {
                        SettingView()
                    } label: {
                        // テキストを表示
                        Text("秒数設定")
                    }
                }
            }
        }
    }
    
    // 1秒ごとに実行されてカウントダウンする
    func countDownTimer() {
        // 経過時間に+1指定していく
        count += 1
        
        // 残り時間が0以下のとき、タイマーを止める
        if timerValue - count <= 0 {
            timerHandler?.invalidate()
        }
    }
    
    // タイマーをカウントダウン開始する関数
    func startTimer() {
        // timerHandlerをアンラップ
        if let timerHandler {
            // もしタイマーが実行中ならスタートしない
            if timerHandler.isValid {
                return
            }
        }
        
        // 残り時間が0以下のとき、経過時間を0に初期化する
        if timerValue - count <= 0 {
            count = 0
        }
        
        // タイマーをスタート
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            countDownTimer()
        }
    }
}

#Preview {
    ContentView()
}
