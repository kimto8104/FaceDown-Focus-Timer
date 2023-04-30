//
//  NowFocusApp.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/02/12.
//

import SwiftUI

@main
struct NowFocusApp: App {
  @StateObject var pomodoroModel: PomodoroModel = .init()
    var body: some Scene {
        WindowGroup {
          MainContentView()
            .environmentObject(pomodoroModel)
        }
    }
}
