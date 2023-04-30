//
//  MainContentView.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/03/13.
//

import SwiftUI

struct MainContentView: View {
  @EnvironmentObject var pomodoroModel: PomodoroModel
  var body: some View {
    // Tab
    TabView {
      // TopView
      TopView()
        .environmentObject(pomodoroModel)
        .tabItem {
          Label("Top", systemImage: "list.dash")
        }
      
      // History
      History()
        .environmentObject(pomodoroModel)
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
