//
//  History.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/12/25.
//

import SwiftUI

struct HistoryPage: View {
  var body: some View {
    GeometryReader { gp in
      let hm = gp.size.width / 375
      let vm = gp.size.height / 667
      let multiplier = abs(hm - 1) < abs(vm - 1) ? hm : vm
      Color.yellow.frame(width: gp.size.width, height: gp.size.height)
    }.ignoresSafeArea(.all)
  }
}

#Preview {
  HistoryPage()
}
