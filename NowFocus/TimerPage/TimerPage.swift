//
//  TimerPage.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/03/07.
//

import SwiftUI
import AVFoundation
import CoreMotion

struct TimerPage: View {
  @StateObject private var viewModel: TimerViewModel
  @Environment(\.presentationMode) var presentationMode
  
  // iPhone を持ち上げたどうかを表すフラグ
  @State private var isIphoneLifted = false
  // モーションマネジャーインスタンス
  @State private var alertIsPresented = false
  
  init(time: Int) {
    self._viewModel = StateObject(wrappedValue: TimerViewModel(time: time * 60))
  }
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(Color.blue, lineWidth: 4)
        .frame(width: 200, height: 200)
      Text(viewModel.remainingTime.asTimeString)
        .font(.largeTitle)
        .foregroundColor(.blue)
        .onReceive(viewModel.$remainingTime) { time in
          if time == 0 {
          }
        }
        .onAppear {
          viewModel.start()
          // 加速度センサーとジャイロスコープからのデータを取得する
          
        }
        .onDisappear(perform: viewModel.stop)
    }
    
    .alert(isPresented: $alertIsPresented) {
      Alert(
        title: Text("タイマーを終了しますか？"),
        primaryButton: .cancel(Text("戻る")),
        secondaryButton: .default(Text("OK"), action: {
          viewModel.stop()
          presentationMode.wrappedValue.dismiss()
        })
      )
    }
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(
      leading: Button(action: {
        self.alertIsPresented = true
      }, label: {
        Image(systemName: "chevron.backward")
        Text("戻る")
      })
    )
  } // body ここまで
  
  func showAlert() {
    let alert = UIAlertController(title: "iPhoneを持ち上げました", message: "タイマーを終了しますか？", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "戻る", style: .cancel))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.viewModel.stop()
      self.presentationMode.wrappedValue.dismiss()
    }))
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
  }
  
  
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    TimerPage(time: 10)
  }
}
