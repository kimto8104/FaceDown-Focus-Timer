//
//  ContentView.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/02/12.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    // Tab
    TabView {
      Text("Home")
        .tabItem {
          VStack {
            Image(systemName: "folder")
            Text("Home")
          }
        }
      
      Text("Tab2")
        .tabItem {
          VStack {
            Image(systemName: "tray")
            Text("Second")
          }
        }
      
      Text("Tab3")
        .tabItem {
          VStack {
            Image(systemName: "externaldrive")
            Text("Third")
          }
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
