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
      TopView()
        .tabItem {
          Label("Top", systemImage: "list.dash")
        }
      
      // History
      History()
        .tabItem {
          Label("History", systemImage: "list.dash")
        }
    }
  }
}

struct MainContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainContentView()
  }
}
