//
//  TimerInteractor.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/07/21.
//

import Foundation
import Combine

protocol TimerInteractorProtocol {
  var presenter: (any TimerPresenterProtocol) { get set}
  func startTimer()
  func pauseTimer()
  func resetTimer()
  
  // MotionManager
  func startMonitoringDeviceMotion()
  func stopMonitoringDeviceMotion()
  func resetMotionManager()
  func checkDeviceMotion()
}

class TimerInteractor: TimerInteractorProtocol {
  var presenter: (any TimerPresenterProtocol)
  private var isFirstTimeActive = true
  private var motionManagerService: MotionManagerService
  private var cancellables = Set<AnyCancellable>()
  
  private var timer: Timer?
  private var remainingTime: TimeInterval
  private let initialTime: TimeInterval
  
  init(initialTime: Int, presenter: any TimerPresenterProtocol, motionManagerService: MotionManagerService) {
    self.remainingTime = TimeInterval(initialTime * 60)
    self.initialTime = TimeInterval(initialTime * 60)
    self.presenter = presenter
    self.motionManagerService = motionManagerService
    setupBindings()
    print("init for TimerInteractor")
  }
  
  private func setupBindings() {
    motionManagerService.$isMoved.sink { [weak self] isMoved in
      guard let self else { return }
      self.presenter.updateIsMoved(isMoved: isMoved)
      
      if self.isFirstTimeActive {
        self.isFirstTimeActive = false
        return
      }
      
      if !isMoved {
        self.startTimer()
      } else {
        self.pauseTimer()
      }
    }
    .store(in: &cancellables)
  }
  
  func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
      guard let self else { return }
      self.remainingTime -= 1
      if self.remainingTime <= 0 {
        self.timer?.invalidate()
        self.resetTimer()
      } else {
        self.presenter.updateTime(time: remainingTime)
      }
    })
  }
  
  func pauseTimer() {
    self.timer?.invalidate()
  }
  
  func resetTimer() {
    timer?.invalidate()
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
  
  func checkDeviceMotion() {
    print("test")
  }
}
