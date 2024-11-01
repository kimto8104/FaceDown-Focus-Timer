//
//  TimeSelectionView.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/02/12.
//

import SwiftUI

struct TimeSelectionView: View {
  @StateObject var presenter = TimeSelectionPresenter()
  // 時間
  let time = [
    1, 15, 30
  ]
  
  var body: some View {
    NavigationStack {
      // time の配列の要素自身をidとして使うときに\.selfというように記載する
      List(presenter.timeOptions, id: \.self) { time in
        presenter.router.goToTimerPage(time: time)
      }
      .navigationTitle("時間選択")
    }
  }
}

struct TimeItem: Identifiable {
  var id: ObjectIdentifier
  var name: String
}

struct TimeSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    TimeSelectionView(presenter: TimeSelectionPresenter())
  }
}
