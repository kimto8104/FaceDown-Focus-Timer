//
//  TimerInteractor.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/07/21.
//

import Foundation

protocol TimerInteractorProtocol {
  var presenter: (any TimerPresenterProtocol)? { get set}
  func startTimer()
  func pauseTimer()
  func resetTimer()
  func checkDeviceMotion()
}

class TimerInteractor: TimerInteractorProtocol {
  var presenter: (any TimerPresenterProtocol)?
  
  private var timer: Timer?
  private var remainingTime: TimeInterval
  private let initialTime: TimeInterval
  
  init(initialTime: Int) {
    self.remainingTime = TimeInterval(initialTime * 60)
    self.initialTime = TimeInterval(initialTime * 60)
  }
  
  func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
      guard let self else { return }
      self.remainingTime -= 1
      if self.remainingTime <= 0 {
        self.timer?.invalidate()
        self.resetTimer()
      } else {
        self.presenter?.updateTime(time: remainingTime)
      }
    })
  }
  
  func pauseTimer() {
    self.timer?.invalidate()
  }
  
  func resetTimer() {
    timer?.invalidate()
    remainingTime = initialTime
    presenter?.updateTime(time: remainingTime)
  }
  
  func checkDeviceMotion() {
    print("test")
  }
}
