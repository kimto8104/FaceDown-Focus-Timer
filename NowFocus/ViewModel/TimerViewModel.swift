//
//  TimerViewModel.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/05/01.
//

import SwiftUI
import AVFoundation

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
      }
    })
  }
  
  private func playSound() {
    audioPlayer?.play()
  }
  
  func stop() {
    timer?.invalidate()
  }
}
