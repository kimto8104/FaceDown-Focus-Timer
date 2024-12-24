//
//  TestView.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/12/21.
//

import SwiftUI

struct TestView: View {
  var body: some View {
//    Color(hex: "FCFFFF")
    GeometryReader { gp in
      let hm = gp.size.width / 375
      let vm = gp.size.height / 667
      let multiplier = abs(hm - 1) < abs(vm - 1) ? hm : vm
      GradientBackgroundUtil.gradientBackground(size: gp.size, multiplier: multiplier)
    }
  }
}

#Preview {
  TestView()
}
