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
    GeometryReader { gp in
      let hm = gp.size.width / 375
      let vm = gp.size.height / 667
      let multiplier = abs(hm - 1) < abs(vm - 1) ? hm : vm
      Color(hex: "282828")
      VStack {
        Spacer()
        instructionText(multiplier: multiplier)
        Spacer()
          .frame(height: 40 * multiplier)
        if presenter.timerState != .completed {
          flipCard(multiplier: multiplier)
            .transition(.opacity) // フェードアウトのためのトランジション
        }
        Spacer()
      }
      .frame(width: gp.size.width, height: gp.size.height)
    }
    .onAppear(perform: {
      presenter.startMonitoringDeviceMotion()
    })
    
    .ignoresSafeArea()
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(
      leading: Button(action: {
        presenter.resetTimer()
        dismiss()
      }, label: {
        Image(systemName: "chevron.backward")
        Text("戻る")
          .foregroundStyle(.white)
      })
    )
    .alert("集中をやめますか？", isPresented: $presenter.showAlertForPause) {
      
      Button("いいえ") {
        // キャンセルなので何もしない
        presenter.stopVibration()
      }
      
      Button("はい") {
        presenter.resetTimer()
        dismiss()
      }
    } message: {
      Text("リセットすると現在のタイマーが失われます")
    }
  } // body ここまで
}

// MARK: Instruction Text
extension TimerPage {
  func instructionText(multiplier: CGFloat) -> some View {
    if presenter.timerState == .completed {
      Text("\(presenter.time.description) 分集中完了しました！")
        .font(.custom("HiraginoSans-W6", size: 20 * multiplier))
        .foregroundStyle(.white)
    } else {
      Text(presenter.isFaceDown ? "画面を上向きにしてタイマーを停止" : "画面を下向きにしてタイマーを開始")
        .font(.custom("HiraginoSans-W6", size: 20 * multiplier))
        .foregroundStyle(.white)
    }
  }
}

// MARK: Flip Card
extension TimerPage {
  func flipCard(multiplier: CGFloat) -> some View {
    VStack {
      Text(presenter.time)
        .font(.custom("HiraginoSans-W6", size: 40 * multiplier))
        .foregroundStyle(.white)
      Image("smartPhone")
        .resizable()
        .frame(width: 147 * multiplier, height: 185 * multiplier)
    }
    .frame(width: 266 * multiplier, height: 360 * multiplier)
    .background(Color(hex: "D9D9D9").opacity(0.23))
    .clipShape(RoundedRectangle(cornerRadius: 20))
    
  }
}

// MARK: Status Text
extension TimerPage {
  func statusText() -> some View {
    // status のTextを表示する　、Pause, Working, Completeの３つ
    Text(presenter.timerState == .completed ? "Completed" : "Pause")
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
    TimerRouter.initializeTimerModule(with: 1)
  }
}
