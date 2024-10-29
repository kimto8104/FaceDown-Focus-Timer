//
//  TimerProgressRing.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/08/20.
//

import SwiftUI

struct TimerProgressRing: View {
  @State var circleProgress: CGFloat = 0.00
  @State var percentageProgress: Int = 0 // %
  
    var body: some View {
      ZStack {
        // Grayのサークル
        Circle()
          .stroke(lineWidth: 20)
          .frame(width: 200, height: 200)
          .foregroundStyle(.gray.opacity(0.3))
        // 青のサークル
        // 円最初の位置０から1(最後の位置)まで描画する
        Circle().trim(from: 0, to: circleProgress)
          // 円を塗りつぶしていく線の指定
          .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round, lineJoin: .round))
          .frame(width: 200, height: 200)
          // 塗りつぶしていく線の色指定
          .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom))
          .rotationEffect(.degrees(-90))
        
        HStack(alignment: .bottom, spacing: 0) {
          Text("\(percentageProgress)").font(.largeTitle).foregroundStyle(.black)
          Text("%").padding(.bottom, 5).foregroundStyle(.black)
        }.bold()
      }
      .onTapGesture {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
          // 100% 以下なら numProgressに+1をし、%を増やす。そしてアニメーションで
          if percentageProgress < 100 {
            percentageProgress += 1
            withAnimation(.linear(duration: 1)) {
              // Circle().trim(from: 0, to: progress) でprogressが１になると100％になるので、numProgressを小数に変換している
              circleProgress = CGFloat(percentageProgress) / 100.0
            }
            
          } else {
            timer.invalidate()
          }
        }
      }
    }
}

#Preview {
    TimerProgressRing()
}
