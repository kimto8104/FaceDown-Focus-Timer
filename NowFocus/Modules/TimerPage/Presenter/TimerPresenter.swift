//
//  TimerPresenter.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/07/21.
//

import Foundation
enum TimerState: String {
  case start
  case paused
  case completed
}

// MARK: Protocol
protocol TimerPresenterProtocol: ObservableObject {
  var interactor: TimerInteractorProtocol? { get set }
  var router: TimerRouterProtocol? { get set }
  
  var time: String { get }
  var isFaceDown: Bool { get }
  var timerState: TimerState { get }
  var showAlertForPause: Bool { get set }
  func resetTimer()
  func stopVibration()
  func updateTime(time: TimeInterval)
  func updateTimerState(timerState: TimerState)
  
  // MotionManager
  func updateIsFaceDown(isFaceDown: Bool)
  func startMonitoringDeviceMotion()
  func stopMonitoringDeviceMotion()
}

class TimerPresenter: TimerPresenterProtocol {
  @Published var time: String = "01:00"
  @Published var isFaceDown = false
  @Published var circleProgress: CGFloat = 0.00
  @Published var percentageProgress: Int = 0
  @Published var timerState: TimerState = .start
  @Published var showAlertForPause = false
  
  var interactor: TimerInteractorProtocol?
  var router: TimerRouterProtocol?
  
  init(time: Int) {
    print("TimerPresenter initialized")
    updateTime(time: TimeInterval(time * 60))
  }
  
  func resumeTimer() {
    interactor?.startTimer()
  }
  
  func resetTimer() {
    interactor?.resetTimer()
  }
  
  func stopVibration() {
    interactor?.stopVibration()
  }
  
  // 00:50のフォーマットに変える
  func updateTime(time: TimeInterval) {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    self.time =  String(format: "%02d:%02d", minutes, seconds)
    print("updateTime: \(self.time)")
  }
  
  func updateTimerState(timerState: TimerState) {
    self.timerState = timerState
  }
  
  func updateIsFaceDown(isFaceDown: Bool) {
    self.isFaceDown = isFaceDown
  }
  
  func startMonitoringDeviceMotion() {
    interactor?.startMonitoringDeviceMotion()
  }
  
  func stopMonitoringDeviceMotion() {
    interactor?.stopMonitoringDeviceMotion()
  }
}
