//
//  TimerRouter.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/07/21.
//

import SwiftUI

// MARK: Protocol
protocol TimerRouterProtocol {
  static func initializeTimerModule(with time: Int) -> AnyView
}

class TimerRouter: TimerRouterProtocol {
  static func initializeTimerModule(with time: Int) -> AnyView {
   
    let router = TimerRouter()
    let interactor = TimerInteractor(initialTime: time)
    let presenter = TimerPresenter(time: time)
    
    
    interactor.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
    
    let view = TimerPage(presenter: presenter)
    return AnyView(view)
  }
}
