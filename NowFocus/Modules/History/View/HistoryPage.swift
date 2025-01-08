//
//  History.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/12/25.
//

import SwiftUI
import SwiftData

struct HistoryPage: View {
  @Environment(\.modelContext) private var modelContext
  @Query(animation: .bouncy) private var allHistory: [FocusHistory]
  
  var body: some View {
    List {
      ForEach(allHistory) {
        Text("ID: \($0.id.description)")
        Text("Start Date: \($0.startDate.description)")
        Text("Focus Duration:\($0.duration.description)")
      }
    }
//    GeometryReader { gp in
//      let hm = gp.size.width / 375
//      let vm = gp.size.height / 667
//      let multiplier = abs(hm - 1) < abs(vm - 1) ? hm : vm
//      Color.yellow.frame(width: gp.size.width, height: gp.size.height)
//
//    }.ignoresSafeArea(.all)
  }
}

#Preview {
  HistoryPage()
}
