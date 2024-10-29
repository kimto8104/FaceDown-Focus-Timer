//
//  MotionServiceWithInitialAttitude.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/08/13.
//

import Foundation
import CoreMotion
import AudioToolbox
import AVFAudio
import AVFoundation

class MotionServiceWithInitialAttitude: ObservableObject {
  private let motionManager = CMMotionManager()
  @Published var isNotMoved = true
  @Published var isMonitoring = false
  @Published var isFaceDown = false
  
  private var initialAttitude: CMAttitude?
  private var audioPlayer: AVAudioPlayer?
  
  // 端末の動き検知を開始
  func startMonitoringDeviceMotion() {
    if motionManager.isDeviceMotionAvailable {
      // 検知間隔を0.5秒に設定
      motionManager.deviceMotionUpdateInterval = 0.5
      // 端末の動き検知開始
      motionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceMotion, error in
        guard let self else { return }
        self.isMonitoring = true
        // 角度や状態についてデータを持っているdeviceMotion
        guard let deviceMotion else { return }
        // 閾値
        let threshold: Double = 0.01
        // 端末が最初の位置にいなければアラームを鳴らす
        if let initialAttitude = self.initialAttitude {
          deviceMotion.attitude.multiply(byInverseOf: initialAttitude)
          // 端末が最初の位置にあるかどうか判定 & 端末画面が下に向いているか判定
          if deviceMotion.attitude.roll > threshold || deviceMotion.attitude.pitch > threshold || deviceMotion.attitude.yaw > threshold {
            // 端末が動いた！
            self.isNotMoved = false
            // 端末画面が下に向いていないかどうか？
            if deviceMotion.gravity.z < 0.75 {
              self.isFaceDown = false
            }
          } else if deviceMotion.gravity.z > 0.75  {
            // 元の位置に端末がある&端末画面が下に向いている
            self.isFaceDown = true
          } else {
            // 端末の画面が上を向いている
            self.isFaceDown = false
          }
        } else {
          // 最初の位置を保存
          self.initialAttitude = deviceMotion.attitude
        }
        let testIsFaceDown = deviceMotion.gravity.z > 0.75
        print("testIsFaceDown: \(testIsFaceDown)")
        // 画面が下向きかどうかを判定する
//        self?.isFaceDown = deviceMotion.gravity.z > 0.75
      }
    }
  }
  
  private func playAlarmSound() {
    // Asset にあるWarning-Siren04-02(Low-Long)を鳴らす
    guard let url = Bundle.main.url(forResource: "Warning-Siren04-02(Low-Long)", withExtension: "mp3") else {
      print("Alarm sound file not found.")
      return
    }
    
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer?.numberOfLoops = -1  // 無限にリピート
      audioPlayer?.prepareToPlay()
      audioPlayer?.play()
    } catch {
      print("Error playing alarm sound: \(error.localizedDescription)")
    }
  }
  
  func stopAlarm() {
    audioPlayer?.stop()
  }
  
  private func triggerAlerm() {
    playAlarmSound()
  }
  
  func stopMonitoring() {
    isMonitoring = false
    motionManager.stopDeviceMotionUpdates()
  }
  
  func reset() {
    initialAttitude = nil
    audioPlayer?.stop()
    isNotMoved = true
    isMonitoring = false
  }
}
