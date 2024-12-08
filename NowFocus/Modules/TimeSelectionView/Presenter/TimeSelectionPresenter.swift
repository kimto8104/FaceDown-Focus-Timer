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

class TimeSelectionPresenter: ObservableObject {
  
  // 選択可能な時間を保持
  @Published var timeOptions = [1]
  // Viewが参照するフラグ
  @Published var shouldShowFloatingBottomSheet = false
  init() {
    self.setupTimeOptions()
  }
  
  // timeOptionsをセットアップする関数
  func setupTimeOptions() {
    var newTimeOptions: [Int] = [1]  // 初期値として1分
    // 各完了済みのフラグをチェックして、対応する時間を追加
    if UserDefaultManager.oneMinuteDoneToday {
      newTimeOptions.append(10)
    }
    
    if UserDefaultManager.tenMinuteDoneToday {
      newTimeOptions.append(15)
    }
    
    if UserDefaultManager.fifteenMinuteDoneToday {
      newTimeOptions.append(30)
    }
    if UserDefaultManager.thirtyMinuteDoneToday {
      newTimeOptions.append(50)
    }
    if newTimeOptions != timeOptions {
      timeOptions = newTimeOptions
    }
  }
  
  func checkFloatingSheetStatus() {
    if !UserDefaultManager.isFloatingBottomSheetShown {
      shouldShowFloatingBottomSheet = true
      UserDefaultManager.isFloatingBottomSheetShown = true
    }
  }
  
  func updateShouldShowFloatingBottomSheets(_ show: Bool) {
    shouldShowFloatingBottomSheet = show
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
