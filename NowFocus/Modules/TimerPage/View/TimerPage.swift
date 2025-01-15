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
  @Environment(\.modelContext) private var modelContext
  @StateObject var presenter: T
  @State private var progress: CGFloat = 0
  @State private var showResultView: Bool = false
  var body: some View {
    GeometryReader { gp in
      let hm = gp.size.width / 375
      let vm = gp.size.height / 667
      let multiplier = abs(hm - 1) < abs(vm - 1) ? hm : vm
      ZStack {
        GradientBackgroundUtil.gradientBackground(size: gp.size, multiplier: multiplier)
        if !showResultView {
          timerView(gp: gp, multiplier: multiplier)
        } else if presenter.totalFocusTime?.isEmpty != nil {
          resultCard(gp: gp, multiplier: multiplier)
        }
      }
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
    .alert("タイマーをリセットしました", isPresented: $presenter.showAlertForPause) {
      Button("OK") {
        presenter.resetTimer()
        presenter.updateTimerState(timerState: .start)
      }
    } message: {
      Text("１分始めることが大事")
    }
  } // body ここまで
}

// MARK: Private TimerPage
extension TimerPage {
  func timerView(gp: GeometryProxy, multiplier: CGFloat) -> some View {
    VStack(spacing: 20 * multiplier) {
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
              ).blur(radius: 2)))
      
    }.position(x: gp.size.width / 2, y: gp.size.height / 2)
  }
  
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
  func resultCard(gp: GeometryProxy, multiplier: CGFloat) -> some View {
    VStack {
      Spacer()
        .frame(height: 200 * multiplier)
      ZStack {
        RoundedRectangle(cornerRadius: 20 * multiplier)
          .fill(Color(hex: "#E8E4E4")!.opacity(1))
          .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 10)
          .frame(width: 314 * multiplier, height: 407 * multiplier)
        VStack(spacing: 60 * multiplier) {
          Text("1分のつもりが")
            .font(.custom("IBM Plex Mono", size: 24 * multiplier))
            .minimumScaleFactor(0.5)
          
          Text("\(presenter.totalFocusTime ?? "20分14秒")も")
            .font(.custom("IBM Plex Mono", size: 40 * multiplier))
            .minimumScaleFactor(0.5)
          
          Text("集中できた！")
            .font(.custom("IBM Plex Mono", size: 32 * multiplier))
            .minimumScaleFactor(0.5)
        }
      }
      
      Spacer().frame(height: 60 * multiplier)
      completeButton(gp: gp, multiplier: multiplier)
      Spacer()
    }
  }
  
  func completeButton(gp: GeometryProxy, multiplier: CGFloat) -> some View {
    Button {
      presenter.resetTimer()
      presenter.stopMonitoringDeviceMotion()
      presenter.updateTimerState(timerState: .start)
//      dismiss()
    } label: {
      Text("完了")
        .foregroundStyle(.black)
        .font(.custom("IBM Plex Mono", size: 20 * multiplier))
        .multilineTextAlignment(.center)
        .frame(width: 176 * multiplier, height: 60 * multiplier)
    }
    
    .frame(width: 176 * multiplier, height: 60 * multiplier)
    .background(Color(hex: "E8E4E4")!.opacity(1))
    .cornerRadius(10 * multiplier)
    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 10)
  }
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    TimerRouter.initializeTimerModule(with: 1)
  }
}
