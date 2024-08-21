//
//  TimerProgressRing.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/08/20.
//

import SwiftUI

struct TimerProgressRing: View {
  @State var progress: CGFloat = 0
  @State var numProgress = 0
  
    var body: some View {
      ZStack {
        // Grayのサークル
        Circle()
          .stroke(lineWidth: 20)
          .frame(width: 200, height: 200)
          .foregroundStyle(.gray.opacity(0.3))
        // 青のサークル
        // 円最初の位置０から1(最後の位置)まで描画する
        Circle().trim(from: 0, to: progress)
          // 円を塗りつぶしていく線の指定
          .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round, lineJoin: .round))
          .frame(width: 200, height: 200)
          // 塗りつぶしていく線の色指定
          .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom))
          .rotationEffect(.degrees(-90))
        
        HStack(alignment: .bottom, spacing: 0) {
          Text("\(numProgress)").font(.largeTitle)
          Text("%").padding(.bottom, 5)
        }.bold()
      }
      .onTapGesture {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
          if numProgress < 100 {
            numProgress += 1
            withAnimation(.linear(duration: 1)) {
              progress = CGFloat(numProgress) / 100.0
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
