//
//  TimerPage.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/03/07.
//

import SwiftUI
import AVFoundation
import CoreMotion
import SwiftData

// MARK: - View
struct TimerPage<T: TimerPresenterProtocol>: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.modelContext) private var modelContext
  @StateObject var presenter: T
  @State private var progress: CGFloat = 0
  @State private var showResultView: Bool = false
  var body: some View {
    GeometryReader { gp in
      let hm = gp.size.width / 375
      let vm = gp.size.height / 667
      let multiplier = abs(hm - 1) < abs(vm - 1) ? hm : vm
      GradientBackgroundUtil.gradientBackground(size: gp.size, multiplier: multiplier)
      VStack(spacing: 20 * multiplier) {
        if !showResultView {
          instructionText(gp: gp, multiplier: multiplier)
            .opacity(showResultView ? 0 : 1)
          circleTimer(multiplier: multiplier, time: presenter.time)
            .opacity(showResultView ? 0 : 1)
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
        
        if showResultView && ((presenter.totalFocusTime?.isEmpty) != nil) {
          congratsText(gp: gp, multiplier: multiplier)
          resultCard(gp: gp, multiplier: multiplier)
            .transition(.blurReplace())
          completeButton(gp: gp, multiplier: multiplier)
        }
      }
      .position(x: gp.size.width / 2, y: gp.size.height / 2)
    }
    .onAppear(perform: {
      presenter.startMonitoringDeviceMotion()
      withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
        progress = 1
      }
    })
    .onChange(of: presenter.isFaceDown,{ _, newValue in
      if newValue == false && presenter.timerState == .completed {
        // SwiftData にFocusHistoryを保存
        if let startDate = presenter.startDate , let totalFocusTimeInTimeInterval = presenter.totalFocusTimeInTimeInterval {
          let focusHistory = FocusHistory(startDate: startDate, duration: totalFocusTimeInTimeInterval)
          modelContext.insert(focusHistory)
          do {
            // SwiftDataに変更があれば保存
            if modelContext.hasChanges {
              try modelContext.save()
            }
          } catch {
            print("Failed to save SwiftData at \(#line) Fix It")
          }
        }
        
        //画面が上向きで集中が完了してるなら結果画面を表示する
        withAnimation(.easeInOut(duration: 1.0)) {
          showResultView = true
        }
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

// MARK: Private TimerPage
extension TimerPage {
  func circleTimer(multiplier: CGFloat, time: String) -> some View {
    ZStack {
      // 背景用のCircleに影をつける
      Circle()
        .fill(Color(hex: "#D1CDCD")!).opacity(0.42)
        .shadow(color: .black.opacity(0.4), radius: 4 * multiplier, x: 10 * multiplier, y: 10 * multiplier)
        .shadow(color: Color(hex: "#FFFCFC")!.opacity(0.3), radius: 10, x: -10, y: -5)
        .frame(width: 240 * multiplier, height: 240 * multiplier)
        .transition(.blurReplace())
      Text(time)
        .foregroundColor(.black)
        .shadow(color: .black.opacity(0.5), radius: 2 * multiplier, x: 0, y: 4 * multiplier)
        .font(.custom("IBM Plex Mono", size: 44 * multiplier))
        .shadow(color: Color(hex: "#FDF3F3")?.opacity(0.25) ?? .clear, radius: 4 * multiplier, x: -4 * multiplier, y: -4 * multiplier)
        .transition(.blurReplace())
    }
  }
  
  func instructionText(gp: GeometryProxy, multiplier: CGFloat) -> some View {
    Text("画面を下向きにしてタイマーを開始")
      .frame(width: gp.size.width * 0.9, height: 60 * multiplier)
      .padding(.horizontal, 10)
      .font(.custom("IBM Plex Mono", size: 20 * multiplier))
      .transition(.blurReplace())
  }
}

// MARK: Private Result View
extension TimerPage {
  
  // Result View
  func congratsText(gp: GeometryProxy, multiplier: CGFloat) -> some View {
    Text("画面を見ないで集中よくできました")
      .frame(width: gp.size.width * 0.9, height: 60 * multiplier)
      .font(.custom("IBM Plex Mono", size: 20 * multiplier))
      .padding(.horizontal, 10)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .transition(.blurReplace())
  }
  
  func resultCard(gp: GeometryProxy, multiplier: CGFloat) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20 * multiplier)
        .fill(Color(hex: "#E8E4E4")!.opacity(0.42))
        .shadow(color: .black.opacity(0.7), radius: 2, x: 6 * multiplier, y: 6 * multiplier)
        .frame(width: 243 * multiplier, height: 302 * multiplier)
      
      VStack {
        Spacer()
          .frame(height: 16 * multiplier)
        Image(systemName: "checkmark.circle")
          .resizable()
          .frame(width: 48 * multiplier, height:  48 * multiplier)
        Spacer()
          .frame(height: 60 * multiplier)
        Text(presenter.totalFocusTime ?? "")
          .frame(width: 243 * multiplier, height: 60 * multiplier)
          .font(.custom("IBM Plex Mono", size: 48 * multiplier))
          .lineLimit(nil) // 行数制限をなくす
          .multilineTextAlignment(.center) // テキストを中央揃え
          .minimumScaleFactor(0.5) // フォントサイズの縮小を許可
        Spacer()
      }
      .frame(width: 243 * multiplier, height: 302 * multiplier) // VStack の範囲を RoundedRectangle に合わせる
    }
  }
  
  func completeButton(gp: GeometryProxy, multiplier: CGFloat) -> some View {
    Button {
      presenter.resetTimer()
      presenter.stopVibration()
      presenter.stopMonitoringDeviceMotion()
      presenter.updateTimerState(timerState: .start)
      dismiss()
    } label: {
      Text("完了")
        .foregroundStyle(.black)
        .font(.custom("IBM Plex Mono", size: 20 * multiplier))
        .multilineTextAlignment(.center)
        .frame(width: 176 * multiplier, height: 60 * multiplier)
    }
    
    .frame(width: 176 * multiplier, height: 60 * multiplier)
    .background(Color(hex: "E8E4E4")!.opacity(0.42))
    .cornerRadius(10 * multiplier)
    .shadow(color: .black.opacity(0.7), radius: 2, x: 6 * multiplier, y: 6 * multiplier)
  }
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    TimerRouter.initializeTimerModule(with: 1)
  }
}
