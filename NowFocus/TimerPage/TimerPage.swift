//
//  TimerPage.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/03/07.
//

import SwiftUI
import AVFoundation

struct TimerPage: View {
  @StateObject private var viewModel: TimerViewModel
  @Environment(\.presentationMode) var presentationMode
  
  @State private var alertIsPresented = false
  
  init(time: Int) {
    self._viewModel = StateObject(wrappedValue: TimerViewModel(time: time * 60))
  }
  
  var body: some View {
    VStack {
      Text(viewModel.remainingTime.asTimeString)
        .font(.largeTitle)
        .onReceive(viewModel.$remainingTime) { time in
          if time == 0 {
            self.alertIsPresented = true
          }
        }
        .onAppear(perform: viewModel.start)
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
  }
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    TimerPage(time: 10)
  }
}
