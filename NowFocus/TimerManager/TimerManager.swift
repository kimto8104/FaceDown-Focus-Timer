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
      updateFormattedTime()
    }
  }
  @Published var formattedTime: String = ""
  private var timer: Timer?
  @Published var isPaused: Bool = true
  
  init(initialTime: Int = 1) {
    // 分数を秒に変える
    self.remainingTime = initialTime * 60
    self.formattedTime = formatTime(seconds: self.remainingTime)
  }
  
  // 最初に押下でタイマー開始
  // タイマー停止の状態で押下するとタイマー再開
  // タイマー動いてる状態で押下するとタイマー停止
  func tapTimerButton() {
    if timer == nil {
      self.startTimer()
    } else if isPaused {
      self.resumeTimer()
    } else {
      self.stopTimer()
    }
  }
  
  // 00:50のフォーマットに変える
  private func formatTime(seconds: Int) -> String {
    let minutes = seconds / 60
    let seconds = seconds % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  private func updateFormattedTime() {
    self.formattedTime = formatTime(seconds: self.remainingTime)
  }
  
  private func startTimer() {
    // タイマーが存在しない場合のみタイマーをスケジュールさせる
    guard timer == nil else { return }
    isPaused = false
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
      guard let self else { return }
      self.remainingTime -= 1
      self.updateFormattedTime()
      print("タイマー稼働中 ")
      if self.remainingTime <= 0 {
        // タイムアップ
        self.stopTimer()
      }
    })
  }
  
  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  private func pauseTimer() {
    if timer != nil {
      isPaused = true
      stopTimer()
    }
  }
  
  private func resumeTimer() {
    if isPaused {
      isPaused = false
      startTimer()
    }
  }
}
