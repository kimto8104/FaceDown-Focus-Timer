//
//  MotionManager.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/12/03.
//

import CoreMotion
import AudioToolbox
import AVFAudio
import AVFoundation

class MotionManager: ObservableObject {
  private let motionManager = CMMotionManager()
  @Published var isMoved = false
  @Published var isMonitoring = false
  private var initialAttitude: CMAttitude?
  private var audioPlayer: AVAudioPlayer?
  // 端末の動き検知を開始
  func startMonitoringDeviceMotion() {
    if motionManager.isDeviceMotionAvailable {
      // 検知間隔を0.5秒に設定
      motionManager.deviceMotionUpdateInterval = 0.5
      // 端末の動き検知開始
      motionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceMotion, error in
        self?.isMonitoring = true
        // 角度や状態についてデータを持っているdeviceMotion
        guard let deviceMotion else { return }
        // 閾値
        let threshold: Double = 0.01
        // 端末が最初の位置にいなければアラームを鳴らす
        if let initialAttitude = self?.initialAttitude {
          deviceMotion.attitude.multiply(byInverseOf: initialAttitude)
          if deviceMotion.attitude.roll > threshold || deviceMotion.attitude.pitch > threshold || deviceMotion.attitude.yaw > threshold {
            // アラームをトリガー
            self?.triggerAlerm()
          } else {
            // 元の位置にあるのでアラームを停止
            self?.stopAlarm()
          }
        } else {
          // 最初の位置を保存
          self?.initialAttitude = deviceMotion.attitude
        }
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
    isMoved = false
  }
  
  private func triggerAlerm() {
    if !isMoved {
      isMoved = true
      playAlarmSound()
    }
  }
  
  func stopMonitoring() {
    isMonitoring = false
    motionManager.stopDeviceMotionUpdates()
  }
  
  func reset() {
    initialAttitude = nil
    audioPlayer?.stop()
    isMoved = false
    isMonitoring = false
  }
}

