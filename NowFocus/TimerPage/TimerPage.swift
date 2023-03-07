//
//  TimerPage.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/03/07.
//

import SwiftUI

struct TimerPage: View {
  let time: Int
    var body: some View {
      Text(time.description)
    }
}

struct TimerPage_Previews: PreviewProvider {
    static var previews: some View {
      TimerPage(time: 10)
    }
}
