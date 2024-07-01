//
//  TimerManager.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/07/01.
//

import Foundation

class TimerManager: ObservableObject {
  @Published var remainingTime: Int
  private var timer: Timer?
  
  init(initialTime: Int) {
    self.remainingTime = initialTime
  }
  
  func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] _ in
      guard let self else { return }
      self.remainingTime -= 1
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
}
