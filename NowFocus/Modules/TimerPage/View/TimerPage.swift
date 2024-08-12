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
struct TimerPage<T: TimerPresenterProtocol>: View {
//  @Environment(\.isPresented) var presentationMode
  @Environment(\.dismiss) var dismiss
//  @ObservedObject private(set) var model = TimerPageVM()
//  @StateObject var timerManager: TimerManager?
  
  @StateObject var presenter: T
  
  var body: some View {
    ZStack {
      Color.white
        .ignoresSafeArea(.all)
      VStack {
        Spacer()
        Text(presenter.isNotMoved ? "集中できています" : "端末を元の位置に戻して" )
          .foregroundStyle(.red)
      }
      // サークルView
      timerCircle()
        .onTapGesture {
          presenter.tapTimerButton()
        }
    }
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(
      leading: Button(action: {
        presenter.resetTimer()
        dismiss()
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
      Text(presenter.isPaused == true ? "▶️" : "\(presenter.time)")
        .font(.largeTitle)
        .foregroundColor(.black)
    }
  }
}

// MARK: - Model
class TimerPageVM: ObservableObject {
  // 上向か下向きかの判定関連
  @Published fileprivate var isFaceUp: Bool = true
  fileprivate var orientationObserver: NSObjectProtocol? = nil
  let notification = UIDevice.orientationDidChangeNotification
  @Published fileprivate var motionManager = MotionManager()
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    let router = TimerRouter.initializeTimerModule(with: 1)
  }
}
