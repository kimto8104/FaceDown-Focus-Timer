//
//  MotionManager.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/12/03.
//

import CoreMotion

class MotionManager {
  private let motionManager = CMMotionManager()
  @Published var isFaceUp = true  // 画面の向きの状態
  init() {
    startAccelerometerUpdates()
  }
  
  private func determineOrientation(acceleration: CMAcceleration) {
    if acceleration.z > 0.75 {
      isFaceUp = false
    } else if acceleration.z < -0.75 {
      isFaceUp = true
    }
  }
  
  private func startAccelerometerUpdates() {
    if motionManager.isAccelerometerAvailable {
      motionManager.accelerometerUpdateInterval = 0.1  // 10Hzの更新頻度
      motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
        if let acceleration = data?.acceleration {
          self?.determineOrientation(acceleration: acceleration)
        }
      }
    }
  }
  
  deinit {
    motionManager.stopAccelerometerUpdates()
  }
}

