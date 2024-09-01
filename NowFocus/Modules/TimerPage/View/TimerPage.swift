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
  @Environment(\.dismiss) var dismiss
  @StateObject var presenter: T
  
  var body: some View {
    ZStack {
      Color.white
        .ignoresSafeArea(.all)
      // サークルView
      timerCircle()
    }
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(
      leading: Button(action: {
        presenter.resetTimer()
        presenter.stopMonitoringDeviceMotion()
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
      // Grayのサークル
      Circle()
        .stroke(lineWidth: 20)
        .frame(width: 200, height: 200)
        .foregroundStyle(.gray.opacity(0.3))
      // 青のサークル
      // 円最初の位置０から1(最後の位置)まで描画する
      Circle().trim(from: 0, to: presenter.circleProgress)
        // 円を塗りつぶしていく線の指定
        .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round, lineJoin: .round))
        .frame(width: 200, height: 200)
        // 塗りつぶしていく線の色指定
        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom))
        .rotationEffect(.degrees(-90))
      
      HStack(alignment: .bottom, spacing: 0) {
        Text("\(presenter.time)").font(.largeTitle).foregroundStyle(.black)
      }.bold()
    }
    .onAppear(perform: {
      presenter.startMonitoringDeviceMotion()
    })
    .onTapGesture {
      presenter.tapTimerButton()
    }
  }
}

// MARK: - Model
class TimerPageVM: ObservableObject {
  // 上向か下向きかの判定関連
  @Published fileprivate var isFaceUp: Bool = true
  fileprivate var orientationObserver: NSObjectProtocol? = nil
  let notification = UIDevice.orientationDidChangeNotification
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    let router = TimerRouter.initializeTimerModule(with: 1)
  }
}
