//
//  TimeSelectionPresenter.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/10/27.
//

import Combine

protocol TimeSelectionPresenterProtocol {
  func removeAllData()
  func makeDoneMinute(time: Int)
}

struct TimeOption: Hashable {
  let time: Int
  let isEnabled: Bool
}

class TimeSelectionPresenter: ObservableObject {
  
  // 選択可能な時間を保持
  @Published var timeOptions: [TimeOption] = []
  init() {
    self.setupTimeOptions()
  }
  
  // timeOptionsをセットアップする関数
  func setupTimeOptions() {
    let newTimeOptions: [TimeOption] = [
      TimeOption(time: 1, isEnabled: true),
//      TimeOption(time: 5, isEnabled: UserDefaultManager.oneMinuteDoneToday),
//      TimeOption(time: 10, isEnabled: UserDefaultManager.fiveMinuteDoneToday),
//      TimeOption(time: 30, isEnabled: UserDefaultManager.fifteenMinuteDoneToday),
//      TimeOption(time: 50, isEnabled: UserDefaultManager.thirtyMinuteDoneToday),
    ]
    // 更新
    timeOptions = newTimeOptions
  }
  
  func removeAllData() {
    UserDefaultManager.deleteAll()
    setupTimeOptions()
  }
}


// MARK: Debug Method
extension TimeSelectionPresenter {
  func makeDoneMinute(time: Int) {
    switch time {
    case 1:
      UserDefaultManager.oneMinuteDoneToday = true
    case 10:
      UserDefaultManager.tenMinuteDoneToday = true
    case 15:
      UserDefaultManager.fifteenMinuteDoneToday = true
    case 30:
      UserDefaultManager.thirtyMinuteDoneToday = true
    case 50:
      UserDefaultManager.fiftyMinuteDoneToday = true
    default:
      break
    }
    
    setupTimeOptions()
  }
}
