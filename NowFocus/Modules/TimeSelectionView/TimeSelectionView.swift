//
//  TimeSelectionView.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/02/12.
//

import SwiftUI

struct TimeSelectionView: View {
  // 時間
  let time = [
    1, 20, 30, 40
  ]
  
  var body: some View {
    NavigationStack {
      // time の配列の要素自身をidとして使うときに\.selfというように記載する
//      List(time, id: \.self) { time in
//        NavigationLink(time.description) {
//          // 遷移先
//          TimerRouter.initializeTimerModule(with: time)
//            .background(.white)
//        }
//      }
//      .navigationTitle("時間選択")
      List(time, id: \.self) { time in
        NavigationLink("\(time) 分", value: time)
      }
      .navigationDestination(for: Int.self, destination: { selectedTime in
        TimerRouter.initializeTimerModule(with: selectedTime)
      })
      .navigationTitle("時間選択")
    }
  }
}

private extension TimeSelectionView {
  func timerView() -> some View {
    Text("test")
  }
}

struct TimeItem: Identifiable {
  var id: ObjectIdentifier
  var name: String
}

struct TimeSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    TimeSelectionView()
  }
}
