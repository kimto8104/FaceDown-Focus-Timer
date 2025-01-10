//
//  History.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/12/25.
//

import SwiftUI
import SwiftData

struct HistoryPage: View {
  @Query(animation: .bouncy) private var allHistory: [FocusHistory]
  @StateObject private var viewModel = HistoryViewModel()
  
  var body: some View {
    GeometryReader { gp in
      let hm = gp.size.width / 375
      let vm = gp.size.height / 667
      let multiplier = abs(hm - 1) < abs(vm - 1) ? hm : vm
      
      ZStack {
        GradientBackgroundUtil.gradientBackground(size: gp.size, multiplier: multiplier)
        VStack {
          Text("合計集中時間")
            .foregroundColor(.black)
            .shadow(color: .black.opacity(0.2), radius: 2 * multiplier, x: 0, y: 4 * multiplier)
            .font(.custom("IBM Plex Mono", size: 24 * multiplier))
            .padding(.bottom, 10)
          
          Text(viewModel.totalDurationFormatted())
            .foregroundColor(.black)
            .shadow(color: .black.opacity(0.2), radius: 2 * multiplier, x: 0, y: 4 * multiplier)
            .font(.custom("IBM Plex Mono", size: 44 * multiplier))
        }
      }
    }
    .onAppear {
      viewModel.updateHistory(with: allHistory)
    }
    .ignoresSafeArea()
  }
}

// MARK: ViewModel
class HistoryViewModel: ObservableObject {
  @Published var allHistory: [FocusHistory] = []
  var totalDuration: TimeInterval {
    allHistory.reduce(0) { $0 + $1.duration }
  }
  
  func updateHistory(with history: [FocusHistory]) {
    allHistory = history
  }
  
  func totalDurationFormatted() -> String {
    let hours = Int(totalDuration) / 3600
    let minutes = (Int(totalDuration) % 3600) / 60
    let seconds = Int(totalDuration) % 60
    
    if hours > 0 {
      return "\(hours)時間\(minutes)分\(seconds)秒"
    } else if minutes > 0 {
      return "\(minutes)分\(seconds)秒"
    } else {
      return "\(seconds)秒"
    }
  }
}

#Preview {
  HistoryPage()
}
