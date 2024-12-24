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
  func stopVibration()
  
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
  
  private var extraFocusStartTime: Date? // タイマー完了後の計測開始時刻
  private var extraFocusTime: TimeInterval = 0 // 追加集中時間

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
      
      if isFaceDown && presenter.timerState != .completed {
        // 画面が下向きでタイマーが完了していない
        print("\(self.remainingTime.description)のタイマーを開始します")
        self.stopVibration()
        self.startTimer()
      } else if !isFaceDown && presenter.timerState != .completed {
        // 画面が上向きで、タイマーが完了していない
        // タイマーは止めるそしてアラートを出してバイブさせる
        self.triggerVibration()
        self.showResetAlertForPause()
        self.pauseTimer()
      } else {
        // 画面が上向きでタイマーを完了した
        self.stopExtraFocusCalculation()
        self.stopVibration()
        self.stopMonitoringDeviceMotion()
        self.presenter.showTotalFocusTime(extraFocusTime: self.extraFocusTime)
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
        self.updateCompletedTimeStatus()
        self.startExtraFocusCalculation() // 追加集中時間計測を開始
        self.resetTimer()
        self.presenter.updateTimerState(timerState: .completed)
        return
      }
      self.presenter.updateTime(time: remainingTime)
    })
  }
  
  private func startExtraFocusCalculation() {
    extraFocusStartTime = Date()
  }
  
  private func stopExtraFocusCalculation() {
    guard let startTime = extraFocusStartTime else { return }
    extraFocusTime += Date().timeIntervalSince(startTime)
    extraFocusStartTime = nil
  }
  
  private func updateCompletedTimeStatus() {
    if initialTime == 60 {
      UserDefaultManager.oneMinuteDoneToday = true
    } else if initialTime == 600 {
      // 10分
      UserDefaultManager.tenMinuteDoneToday = true
    } else if initialTime == 900 {
      // 15分
      UserDefaultManager.fifteenMinuteDoneToday = true
    } else if initialTime == 1800 {
      // 30分
      UserDefaultManager.thirtyMinuteDoneToday = true
    } else if initialTime == 3000 {
      // 50分
      UserDefaultManager.fiftyMinuteDoneToday = true
    }
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
  
  /// タイマー途中で画面を上向きにした場合に続けるかどうか？のアラートを出す
  private func showResetAlertForPause() {
    presenter.showAlertForPause = true
  }
  
  func stopVibration() {
    isVibrating = false
    vibrationTimer?.invalidate()
    vibrationTimer = nil
  }
  
  func pauseTimer() {
    self.timer?.invalidate()
  }
  
  func resetTimer() {
    timer?.invalidate()
    timer = nil
    remainingTime = initialTime
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
}
