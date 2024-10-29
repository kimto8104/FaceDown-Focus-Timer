//
//  TimeSelectionRouter.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/08/05.
//

import Foundation
import SwiftUI

class TimeSelectionRouter {
  func goToTimerPage(time: Int) -> some View {
    return NavigationLink(destination:  TimerRouter.initializeTimerModule(with: time)
      .background(.white)) {
        Text("\(time.description)分")
      }
  }
}
