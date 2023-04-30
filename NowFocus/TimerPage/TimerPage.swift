//
//  TimerPage.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/03/07.
//

import SwiftUI
import AVFoundation
struct TimerPage: View {
  @EnvironmentObject var pomodoroModel: PomodoroModel
  // タイマーの残り時間
  @State var time: Int
  // タイマー
  @State var timer: Timer?
  // エラーアラート
  @State var showingAlert = false
  // AVAudioPlayer
  var audioPlayer: AVAudioPlayer?
  let tenMinData = NSDataAsset(name: "10minAlert")!.data
  
  init(time: Int) {
    // ??
    self._time = State(initialValue: time)
    do {
      audioPlayer = try? AVAudioPlayer(data: tenMinData)
    } catch {
      showingAlert = true
    }
  }
  var body: some View {
    VStack {
      Text(time.description)
        .onAppear {
          // 選択されたタイマー時間を残りの時間変数に代入
          timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            // 1秒経つごとに呼ばれる
            time -= 1
            if time <= 0 {
              // タイマー終了したらタイマーを無効化
              timer?.invalidate()
              do {
                try audioPlayer?.play()
              } catch {
                showingAlert = true
                print(error.localizedDescription)
              }
            } // if 文ここまで
          }) // timer ここまで
        } // onAppear ここまで
    } // VStackここまで
    .alert("音声再生関連でエラーです", isPresented: $showingAlert) {
      Button("OK") {}
    }
  } // bodyここまで
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    TimerPage(time: 10)
      .environmentObject(PomodoroModel())
  }
}
