//
//  UserDefaultManager.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/11/06.
//

import Foundation

class UserDefaultManager: NSObject {
  
  class func setBool(_ boolValue: Bool, forKey: String) {
    UserDefaults.standard.set(boolValue, forKey: forKey)
    UserDefaults.standard.synchronize() // 即座にディスクに保存
  }
  
  class func boolForKey(_ key: String) -> Bool {
    UserDefaults.standard.bool(forKey: key)
  }
}

extension UserDefaultManager {
  // 1分を今日完了したか？
  static var oneMinuteDoneToday: Bool {
    get { return boolForKey(#function) }
    set { setBool(newValue, forKey: #function) }
  }
}


