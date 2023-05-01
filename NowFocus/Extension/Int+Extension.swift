//
//  Int+Extension.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/05/01.
//
import Foundation

extension Int {
  var asTimeString: String {
    let minutes = self / 60
    let seconds = self % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}
