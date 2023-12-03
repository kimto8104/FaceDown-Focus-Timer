//
//  TimerPage.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/03/07.
//

import SwiftUI
import AVFoundation
import CoreMotion

// MARK: - View
struct TimerPage: View {
  @StateObject private var viewModel: TimerViewModel
  @Environment(\.presentationMode) var presentationMode
  @State private var alertIsPresented = false
 
  @ObservedObject private(set) var model = TimerPageVM()
  init(time: Int) {
    self._viewModel = StateObject(wrappedValue: TimerViewModel(time: time * 60))
  }
  
  var body: some View {
    ZStack {
      VStack {
        Text(model.isFaceUp ? "画面が上向きになっています" : "画面が下向きです")
        Spacer()
      }
      // サークルView
      timerCircle()
    }
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(
      leading: Button(action: {
        self.alertIsPresented = true
      }, label: {
        Image(systemName: "chevron.backward")
        Text("戻る")
      })
    )
  } // body ここまで
}

// MARK: Content View
extension TimerPage {
  
  func timerCircle() -> some View {
    // Timer の丸
    Circle()
      .stroke(Color.blue, lineWidth: 4)
      .frame(width: 200, height: 200)
  }
}

// MARK: - View Model
class TimerPageVM: ObservableObject {
  // 上向か下向きかの判定関連
  @Published fileprivate var isFaceUp: Bool = true
  fileprivate var orientationObserver: NSObjectProtocol? = nil
  let notification = UIDevice.orientationDidChangeNotification
  private var motionManager = MotionManager()
  init() {
    setupMotionManager()
  }
  
  private func setupMotionManager() {
    motionManager.$isFaceUp.assign(to: &$isFaceUp)
  }
  // デバイスの向きの検知を開始
//  func startInspect() {
//    // 検知開始
//    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
//    orientationObserver = NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .main, using: { [weak self] _ in
//      switch UIDevice.current.orientation {
//      case .faceUp:
//        self?.isFaceUp = true
//      case .faceDown:
//        self?.isFaceUp = false
//      default:
//        print("other orientation")
//      }
//    })
//  }
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    TimerPage(time: 10)
  }
}
