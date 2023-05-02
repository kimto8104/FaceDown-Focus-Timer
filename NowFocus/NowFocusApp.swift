//
//  NowFocusApp.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/02/12.
//

import SwiftUI
import UserNotifications
@main
struct NowFocusApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
          MainContentView()
        }
    }
}
