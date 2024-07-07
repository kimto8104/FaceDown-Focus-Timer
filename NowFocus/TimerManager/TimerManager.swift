//
//  TimerManager.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/07/01.
//

import Foundation

class TimerManager: ObservableObject {
  @Published var remainingTime: Int {
    didSet {
      print("残り時間: \(remainingTime)")
    }
  }
  private var timer: Timer?
  private var isPaused: Bool = false
  
  init(initialTime: Int) {
    // 分数を秒に変える
    self.remainingTime = initialTime * 60
  }
  
  var formattedTime: String {
    let minutes = remainingTime / 60
    let seconds = remainingTime % 60
    // 整数をゼロパディングして 2 桁で表示するフォーマット指定
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  func startTimer() {
    // タイマーが存在しない場合のみタイマーをスケジュールさせる
    guard timer == nil else { return }
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
      guard let self else { return }
      self.remainingTime -= 1
      print("タイマー稼働中 ")
      if self.remainingTime <= 0 {
        // タイムアップ
        self.stopTimer()
      }
    })
  }
  
  func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  func pauseTimer() {
    if timer != nil {
      isPaused = true
      stopTimer()
    }
  }
  
  func resumeTimer() {
    if isPaused {
      isPaused = false
      startTimer()
    }
  }
}
