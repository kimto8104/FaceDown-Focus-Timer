//
//  TimeSelectionPresenter.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/10/27.
//

import Combine

protocol TimeSelectionPresenterProtocol {
  
}

class TimeSelectionPresenter: ObservableObject {
  
  // 選択可能な時間を保持
  @Published var timeOptions = [1]
  // Routerインスタンス
  let router: TimeSelectionRouter
  // イニシャライザでRouterを注入
  init(router: TimeSelectionRouter = TimeSelectionRouter()) {
    self.router = router
  }
}
