//
//  TabBar.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/12/25.
//

import SwiftUI

struct TabBarView: View {
  @Binding var selectedTab: TabIcon
  @State var Xoffset = 0.0
  var multiplier: CGFloat
  var body: some View {
    HStack {
      ForEach(Array(tabItems.enumerated()), id: \.element.id) { index, item in
        Spacer()
        Image(systemName: item.iconname)
          .resizable()
          .bold()
          .frame(width: 24 * multiplier, height: 24 * multiplier)
          .symbolVariant(selectedTab == item.tab ? .fill : .none)
          .contentTransition(.symbolEffect)
          .onTapGesture {
            withAnimation(.spring()) {
              selectedTab = item.tab
              Xoffset = (CGFloat(index) * 70) * multiplier
            }
          }
        Spacer()
      }.frame(width: 23.3 * multiplier)
    }.frame(height: 70 * multiplier)
      .background(.thinMaterial, in: .rect(cornerRadius: 20 * multiplier))
      .overlay(alignment: .bottomLeading) {
        Circle().frame(width: 10 * multiplier, height: 10 * multiplier)
          .offset(x: 30 * multiplier, y: -5 * multiplier).offset(x: Xoffset)
      }
  }
}

struct TabBar: Identifiable {
  var id = UUID()
  var iconname: String
  var tab: TabIcon
}

let tabItems = [
  TabBar(iconname: "house", tab: .Home),
  TabBar(iconname: "clock", tab: .Clock),
//  TabBar(iconname: "location", tab: .Location),
//  TabBar(iconname: "calendar", tab: .Purchases),
//  TabBar(iconname: "gear", tab: .Notification)
]
enum TabIcon: String {
  case Home
  case Clock
//  case Location
//  case Purchases
//  case Notification
}

#Preview {
  let selectedTab = Binding<TabIcon>.constant(.Home)
  TabBarView(selectedTab: selectedTab, multiplier: 1)
}
