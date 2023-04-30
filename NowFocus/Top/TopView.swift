//
//  TopView.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/02/12.
//

import SwiftUI

struct TopView: View {
  // 時間
  @State var time = [
    5, 20, 30, 40
  ]
  
  @EnvironmentObject var pomodoroModel: PomodoroModel
  var body: some View {
    NavigationStack {
      // time の配列の要素自身をidとして使うときに\.selfというように記載する
      List(time, id: \.self) { time in
        NavigationLink(time.description) {
          // 遷移先
          TimerPage(time: time)
            .environmentObject(pomodoroModel)
        }
      }
      .navigationTitle("時間選択")
    }
  }
}

private extension TopView {
  func timerView() -> some View {
    Text("test")
  }
}

struct TimeItem: Identifiable {
  var id: ObjectIdentifier
  var name: String
}
struct TopView_Previews: PreviewProvider {
  static var previews: some View {
    TopView()
      .environmentObject(PomodoroModel())
  }
}
