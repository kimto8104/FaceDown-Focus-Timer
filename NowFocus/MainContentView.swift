//
//  MainContentView.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/03/13.
//

import SwiftUI

struct MainContentView: View {
  @State private var selectedTab: TabIcon = .Home // タブの状態を管理
  @State private var isTimerPageActive: Bool = false
  var body: some View {
    GeometryReader { gp in
      let hm = gp.size.width / 375
      let vm = gp.size.height / 667
      let multiplier = abs(hm - 1) < abs(vm - 1) ? hm : vm
      // 現在のタブに応じたコンテンツを表示
      TabContentView(selectedTab: selectedTab, isTimerPageActive: $isTimerPageActive)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all) // コンテンツを画面全体に広げる
      VStack {
        Spacer()
        TabBarView(selectedTab: $selectedTab, multiplier: multiplier)
        Spacer()
          .frame(height: 10 * multiplier)
      }
      .opacity(isTimerPageActive ? 0 : 1)
      .animation(.easeInOut, value: isTimerPageActive)
      .frame(width: gp.size.width)
    }
  }
}

struct MainContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainContentView()
  }
}

// コンテンツ切り替え用ビュー
struct TabContentView: View {
  var selectedTab: TabIcon
  @Binding var isTimerPageActive: Bool
  var body: some View {
    switch selectedTab {
    case .Home:
      TimeSelectionView(presenter: TimeSelectionPresenter(), isTimerPageActive: $isTimerPageActive) // 現在のビュー
    case .Clock:
      HistoryPage()
    }
  }
}
