//
//  Color+Extension.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2024/09/20.
//

import Foundation
import SwiftUI

extension Color {
  init?(hex: String) {
    // 入力文字列の先頭に # があれば除去
    let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
    
    // 6桁の16進数であることを確認
    guard hex.count == 6, Scanner(string: hex).scanHexInt64(nil) else {
      return nil // 不正な入力の場合はnilを返す
    }
    
    // スキャナで16進数を解析
    let scanner = Scanner(string: hex)
    var hexNumber: UInt64 = 0
    scanner.scanHexInt64(&hexNumber)
    
    // RGB値を抽出
    let r = Double((hexNumber & 0xFF0000) >> 16) / 255
    let g = Double((hexNumber & 0x00FF00) >> 8) / 255
    let b = Double(hexNumber & 0x0000FF) / 255
    
    // 初期化
    self.init(red: r, green: g, blue: b)
  }
}

