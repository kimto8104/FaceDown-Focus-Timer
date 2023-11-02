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
      // Timer の丸
      Circle()
        .stroke(Color.blue, lineWidth: 4)
        .frame(width: 200, height: 200)
      // 残り時間
      Text(viewModel.remainingTime.asTimeString)
        .font(.largeTitle)
        .foregroundColor(.blue)
        .onReceive(viewModel.$remainingTime) { time in
          if time == 0 {
            // time が0ならタイマーを止める
            viewModel.stop()
          }
        }
        .onAppear {
          // 端末の向きがFaceUpではない場合Timerスタートする
          if model.isFaceUp == false {
            viewModel.start()
          }
        }
        .onDisappear(perform: viewModel.stop)
    }
    // isFaceUpの値を監視、falseならタイマースタート
    .onReceive(model.$isFaceUp, perform: { isFaceUp in
      let _ = print("isFaceUp? \(isFaceUp)")
      if model.isFaceUp == false {
        viewModel.start()
      }
    })
    
    .onAppear {
      // 画面の向きの見地を開始
      model.startInspect()
    }
    
    
    .alert("デバイスの画面を下に向けてください", isPresented: $model.isFaceUp, actions: {
      Button("OK") {
        if model.isFaceUp == false {
          viewModel.start()
        }
      }
    })
    
    .alert(isPresented: $alertIsPresented) {
      Alert(
        title: Text("タイマーを終了しますか？"),
        primaryButton: .cancel(Text("戻る")),
        secondaryButton: .default(Text("OK"), action: {
          viewModel.stop()
          presentationMode.wrappedValue.dismiss()
        })
      )
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

// MARK: - View Model
class TimerPageVM: ObservableObject {
  // 上向か下向きかの判定関連
  @Published fileprivate var isFaceUp: Bool = true
  fileprivate var orientationObserver: NSObjectProtocol? = nil
  let notification = UIDevice.orientationDidChangeNotification
  
  // デバイスの向きの検知を開始
  func startInspect() {
    // 検知開始
    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    orientationObserver = NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .main, using: { [weak self] _ in
      switch UIDevice.current.orientation {
      case .faceUp:
        self?.isFaceUp = true
//      case .faceDown:
//        self?.isFaceUp = false
      default:
        print("other orientation")
      }
    })
  }
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    TimerPage(time: 10)
  }
}
