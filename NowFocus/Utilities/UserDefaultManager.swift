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
  
  class func deleteAll() {
    UserDefaults.standard.removePersistentDomain(forName: "com.tomoapp.face.down.timer")
  }
}

extension UserDefaultManager {
  // 1分を今日完了したか？
  static var oneMinuteDoneToday: Bool {
    get { return boolForKey(#function) }
    set { setBool(newValue, forKey: #function) }
  }
  
  // 10分を今日完了したか？
  static var tenMinuteDoneToday: Bool {
    get { return boolForKey(#function) }
    set { setBool(newValue, forKey: #function) }
  }
  
  // 15分を今日完了したか？
  static var fifteenMinuteDoneToday: Bool {
    get { return boolForKey(#function) }
    set { setBool(newValue, forKey: #function) }
  }
  
  // 30分を今日完了したか？
  static var thirtyMinuteDoneToday: Bool {
    get { return boolForKey(#function) }
    set { setBool(newValue, forKey: #function) }
  }
  
  // 30分を今日完了したか？
  static var fiftyMinuteDoneToday: Bool {
    get { return boolForKey(#function) }
    set { setBool(newValue, forKey: #function) }
  }
  
  
}


