//
//  TimerViewModel.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/05/01.
//

import SwiftUI
import AVFoundation
import UserNotifications

class TimerViewModel: ObservableObject {
  @Published var remainingTime: Int
  var onUpdate: ((Int) -> Void)?
  
  private var timer: Timer?
  private let audioPlayer: AVAudioPlayer?
  private let tenMinData = NSDataAsset(name: "10minAlert")!.data
  
  init(time: Int) {
    self.remainingTime = time
    audioPlayer = try? AVAudioPlayer(data: self.tenMinData)
  }
  
  func start() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
      self.remainingTime -= 1
      self.onUpdate?(self.remainingTime)
      if self.remainingTime <= 0 {
        self.timer?.invalidate()
        self.playSound()
        self.scheduleNotification()
      }
    })
  }
  
  private func playSound() {
    audioPlayer?.play()
  }
  
  func stop() {
    timer?.invalidate()
  }
  
  private func scheduleNotification() {
    // ユーザーに通知の許可を求める
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { granted, error in
      // 許可がされていない場合、またはエラーがある場合は処理を中止する
      guard granted, error == nil else { return }
      
      // 通知のコンテンツを作成する
      let content = UNMutableNotificationContent()
      content.title = "タイマーが終了しました"
      content.body = "タイマーが完了しました"
      content.sound = UNNotificationSound.default
      
      // 通知のトリガーを作成する
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
      
      // 通知をスケジュールする
      center.add(request)
    }
  }
  
}
