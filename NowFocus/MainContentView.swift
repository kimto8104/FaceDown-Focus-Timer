//
//  MainContentView.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/03/13.
//

import SwiftUI

struct MainContentView: View {
  var body: some View {
    // Tab
    TabView {
      // TopView
      TimeSelectionView(presenter: TimeSelectionPresenter())
        .tabItem {
          Label("Top", systemImage: "list.dash")
        }
    }
  }
}

struct MainContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainContentView()
  }
}
