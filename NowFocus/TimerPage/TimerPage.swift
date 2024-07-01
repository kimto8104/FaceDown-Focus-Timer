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
  @StateObject private var motionManager = MotionManager()
  @Environment(\.presentationMode) var presentationMode
  @State private var alertIsPresented = false
 
  @ObservedObject private(set) var model = TimerPageVM()
  init(time: Int) {
    
  }
  
  var body: some View {
    ZStack {
      VStack {
        Spacer()
      }
      
      Button {
        // モニタリング再開
        motionManager.startMonitoringDeviceMotion()
      } label: {
        Text(motionManager.isMoved ? "元の位置に戻してください" : "集中できています")
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
    ZStack {
      Circle()
        .stroke(Color.blue, lineWidth: 4)
        .frame(width: 200, height: 200)
      Text("50:00")
        .font(.largeTitle)
        .foregroundColor(.black)
    }
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
    
  }
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    TimerPage(time: 10)
  }
}
