//
//  TimeSelectionView.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/02/12.
//

import SwiftUI

struct TimeSelectionView: View {
  @ObservedObject var presenter:TimeSelectionPresenter
  @State private var showActionSheet = false  // ActionSheet表示用のフラグ
  var body: some View {
    NavigationStack {
      // time の配列の要素自身をidとして使うときに\.selfというように記載する
      List(presenter.timeOptions, id: \.self) { time in
        presenter.router.goToTimerPage(time: time)
      }
      .onAppear(perform: {
        presenter.setupTimeOptions()
      })
      .navigationTitle("時間選択")
      .navigationBarItems(trailing: Button("Debug") {
        // Show Action Sheet
        showActionSheet = true
        
      })
      .confirmationDialog("デバッグメニュー", isPresented: $showActionSheet) {
        Button("1分完了") {
          presenter.makeDoneMinute(time: 1)
        }
        
        Button("10分完了") {
          presenter.makeDoneMinute(time: 10)
        }
        
        Button("15分完了") {
          presenter.makeDoneMinute(time: 15)
        }
        
        Button("30分完了") {
          presenter.makeDoneMinute(time: 30)
        }
        
        Button("データ削除") {
          presenter.removeAllData()
        }
      }
    }
  }
}

struct TimeSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    TimeSelectionView(presenter: TimeSelectionPresenter())
  }
}
