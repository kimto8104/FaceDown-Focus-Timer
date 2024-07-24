//
//  TimerPresenter.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/07/21.
//

import Foundation

// MARK: Protocol
protocol TimerPresenterProtocol: ObservableObject {
  var interactor: TimerInteractorProtocol? { get set }
  var router: TimerRouterProtocol? { get set }
  
  var time: String { get }
  var isPaused: Bool { get }
  
  func tapTimerButton()
  func resetTimer()
  func updateTime(time: TimeInterval)
}

class TimerPresenter: TimerPresenterProtocol {
  @Published var time: String = "01:00"
  @Published var isPaused: Bool = true
  
  var interactor: TimerInteractorProtocol?
  var router: TimerRouterProtocol?
  
  init(interactor: TimerInteractorProtocol?, router: TimerRouterProtocol?) {
    self.interactor = interactor
    self.router = router
  }
  
  func tapTimerButton() {
    if isPaused {
       interactor?.startTimer()
    } else {
       interactor?.pauseTimer()
    }
    isPaused.toggle()
  }
  
  func resetTimer() {
    interactor?.resetTimer()
    isPaused = true
  }
  
  // 00:50のフォーマットに変える
  func updateTime(time: TimeInterval) {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    self.time =  String(format: "%02d:%02d", minutes, seconds)
    print("updateTime: \(self.time)")
  }
}
