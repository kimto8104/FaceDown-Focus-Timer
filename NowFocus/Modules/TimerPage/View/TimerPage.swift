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
  @State private var progress: CGFloat = 0
  var body: some View {
    GeometryReader { gp in
      let hm = gp.size.width / 375
      let vm = gp.size.height / 667
      let multiplier = abs(hm - 1) < abs(vm - 1) ? hm : vm
      GradientBackgroundUtil.gradientBackground(size: gp.size, multiplier: multiplier)
      VStack(spacing: 20 * multiplier) {
        instructionText(gp: gp, multiplier: multiplier)
        circleTimer(multiplier: multiplier, time: presenter.time)
          .overlay(
            Circle()
              .stroke(.clear, lineWidth: 2)
              .overlay(Circle()
                .trim(from: max(0, progress - 0.1), to: progress)
                .stroke(
                  LinearGradient(colors: [.white, .black ], startPoint: .leading, endPoint: .trailing),
                  style: StrokeStyle(lineWidth: 4, lineCap: .round)
                ).blur(radius: 2))
          )
      }
      .position(x: gp.size.width / 2, y: gp.size.height / 2)
    }
    .onAppear(perform: {
      presenter.startMonitoringDeviceMotion()
      withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
        progress = 1
      }
    })
    
    .ignoresSafeArea()
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(
      leading: Button(action: {
        presenter.resetTimer()
        presenter.stopMonitoringDeviceMotion()
        presenter.updateTimerState(timerState: .start)
        dismiss()
      }, label: {
        Image(systemName: "chevron.backward")
        Text("戻る")
          .foregroundStyle(.black)
      })
    )
    .alert("集中をやめますか？", isPresented: $presenter.showAlertForPause) {
      
      Button("いいえ") {
        // キャンセルなので何もしない
        presenter.stopVibration()
      }
      
      Button("はい") {
        presenter.resetTimer()
        presenter.stopVibration()
        presenter.stopMonitoringDeviceMotion()
        presenter.updateTimerState(timerState: .start)
        dismiss()
      }
    } message: {
      Text("リセットすると現在のタイマーが失われます")
    }
  } // body ここまで
}

// MARK: Private
extension TimerPage {
  func circleTimer(multiplier: CGFloat, time: String) -> some View {
    ZStack {
      // 背景用のCircleに影をつける
      Circle()
        .fill(Color(hex: "#D1CDCD")!).opacity(0.42)
        .shadow(color: .black.opacity(0.4), radius: 4 * multiplier, x: 10 * multiplier, y: 10 * multiplier)
        .shadow(color: Color(hex: "#FFFCFC")!.opacity(0.3), radius: 10, x: -10, y: -5)
        .frame(width: 240 * multiplier, height: 240 * multiplier)
      Text(time)
        .foregroundColor(.black)
        .shadow(color: .black.opacity(0.5), radius: 2 * multiplier, x: 0, y: 4 * multiplier)
        .font(.custom("IBM Plex Mono", size: 44 * multiplier))
        .shadow(color: Color(hex: "#FDF3F3")?.opacity(0.25) ?? .clear, radius: 4 * multiplier, x: -4 * multiplier, y: -4 * multiplier)
    }
  }
  
  func instructionText(gp: GeometryProxy, multiplier: CGFloat) -> some View {
    Text("画面を下向きにしてタイマーを開始")
      .frame(width: gp.size.width * 0.9, height: 60 * multiplier)
      .padding(.horizontal, 10)
      .font(.custom("IBM Plex Mono", size: 20 * multiplier))
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
