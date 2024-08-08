//
//  TimerRouter.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/07/21.
//

import SwiftUI

// MARK: Protocol
protocol TimerRouterProtocol {
  static func initializeTimerModule(with time: Int) -> TimerPage<TimerPresenter>
}

class TimerRouter: TimerRouterProtocol {
  static func initializeTimerModule(with time: Int) -> TimerPage<TimerPresenter> {
    print("initializeTimerModule呼ばれています")
    let router = TimerRouter()
    let motionManagerService = MotionManagerService()
    let presenter = TimerPresenter(time: time)
    let interactor = TimerInteractor(initialTime: time, presenter: presenter, motionManagerService: motionManagerService)
    
    presenter.interactor = interactor
    presenter.router = router
    
    let view = TimerPage(presenter: presenter)
    return view
  }
}
