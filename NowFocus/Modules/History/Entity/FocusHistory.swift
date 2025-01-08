//
//  FocusHistory.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2025/01/07.
//

import Foundation
import SwiftData

@Model
class FocusHistory {
  // データID
  @Attribute(.unique) var id: UUID = UUID()
  // 開始日付
  var startDate: Date
  var duration: TimeInterval
  
  init(startDate: Date, duration: TimeInterval) {
    self.startDate = startDate
    self.duration = duration
  }
}
