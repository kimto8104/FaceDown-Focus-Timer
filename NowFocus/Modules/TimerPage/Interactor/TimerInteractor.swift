//
//  TimerInteractor.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/07/21.
//

import Foundation
import Combine
import AudioToolbox

protocol TimerInteractorProtocol {
  var presenter: (any TimerPresenterProtocol) { get set}
  func startTimer()
  func pauseTimer()
  func resetTimer()
  
  // MotionManager
  func startMonitoringDeviceMotion()
  func stopMonitoringDeviceMotion()
  func resetMotionManager()
}

class TimerInteractor: TimerInteractorProtocol {
  var presenter: (any TimerPresenterProtocol)
  private var isFirstTimeActive = true
  private var motionManagerService: MotionManagerService
  private var cancellables = Set<AnyCancellable>()
  
  private var timer: Timer?
  private var remainingTime: TimeInterval
  private let initialTime: TimeInterval
  private var vibrationTimer: Timer?
  private var isVibrating: Bool = false
  
  init(initialTime: Int, presenter: any TimerPresenterProtocol, motionManagerService: MotionManagerService) {
    self.remainingTime = TimeInterval(initialTime * 60)
    self.initialTime = TimeInterval(initialTime * 60)
    self.presenter = presenter
    self.motionManagerService = motionManagerService
    setupBindings()
  }
  
  private func setupBindings() {
    // isFaceDownの監視、trueになるとタイマーを停止、falseになるとタイマーをスタートさせる
    motionManagerService.$isFaceDown.sink { [weak self] isFaceDown in
      guard let self else { return }
      self.presenter.updateIsFaceDown(isFaceDown: isFaceDown)
      
      if self.isFirstTimeActive {
        self.isFirstTimeActive = false
        return
      }
      
      if isFaceDown {
        self.startTimer()
      } else {
        self.stopVibration()
        self.pauseTimer()
      }
    }
    .store(in: &cancellables)
  }
  
  func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
      guard let self else { return }
      if self.remainingTime > 0 {
        self.remainingTime -= 1
      } else {
        // タイマー完了
        self.triggerVibration()
        self.resetTimer()
        return
      }
      
      self.presenter.updateTime(time: remainingTime)
    })
  }
  
  private func triggerVibration() {
    // 既にバイブレーションが動いている場合は、再度トリガーしない
    guard !isVibrating else { return }
    isVibrating = true
    // タイマーを使って1秒ごとにバイブレーションを繰り返す
    vibrationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
  }
  
  private func stopVibration() {
    isVibrating = false
    vibrationTimer?.invalidate()
    vibrationTimer = nil
  }
  
  func pauseTimer() {
    motionManagerService.stopAlarm()
    self.timer?.invalidate()
  }
  
  func resetTimer() {
    timer?.invalidate()
    remainingTime = 0
    timer = nil
    presenter.updateTime(time: remainingTime)
  }
  
  func startMonitoringDeviceMotion() {
    motionManagerService.startMonitoringDeviceMotion()
  }
  
  func stopMonitoringDeviceMotion() {
    motionManagerService.stopMonitoring()
  }
  
  func resetMotionManager() {
    motionManagerService.reset()
  }
  
  func checkDeviceMotion() {
    print("test")
  }
}
