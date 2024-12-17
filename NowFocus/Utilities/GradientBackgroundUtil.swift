//
//  GradientBackgroundUtil.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/12/16.
//

import SwiftUI

struct GradientBackgroundUtil {
  static func gradientBackground(
    size: CGSize,
    multiplier: CGFloat
  ) -> some View {
    LinearGradient(
      gradient: Gradient(stops: [
        .init(color: Color(hex: "#E7E4E4") ?? .clear, location: 0.0 * multiplier),
        .init(color: Color(hex: "#D5D0D0") ?? .clear, location: 0.53 * multiplier),
        .init(color: (Color(hex: "#DAD2D2") ?? .clear).opacity(0.6), location: 0.62 * multiplier),
        .init(color: (Color(hex: "#B6B0B0") ?? .clear).opacity(0.8), location: 1.0 * multiplier)
      ]),
      startPoint: .top,
      endPoint: .bottom
    )
    .ignoresSafeArea()
    .frame(width: size.width, height: size.height)
  }
}

