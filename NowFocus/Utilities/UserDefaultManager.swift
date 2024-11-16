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
  
  // 前回のチェック日を取得・更新
  static var lastCheckedDate: Date {
    get { return UserDefaults.standard.object(forKey: #function) as? Date ?? Date() }
    set { UserDefaults.standard.set(newValue, forKey: #function) }
  }
  
  // 日付が変わっていればデイリーデータをリセット
  static func resetDailyDataIfDateChanged() {
    let today = Calendar.current.startOfDay(for: Date())
    let lastChecked = Calendar.current.startOfDay(for: lastCheckedDate)
    // 最後の確認日と今日の日付を比較し、変わっていればリセット
    if today > lastChecked {
      resetAllDate()
    }
  }
  
  private static func resetAllDate() {
    oneMinuteDoneToday = false
    tenMinuteDoneToday = false
    fifteenMinuteDoneToday = false
    thirtyMinuteDoneToday = false
    fiftyMinuteDoneToday = false
  }
  
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


