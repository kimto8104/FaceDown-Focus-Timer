//
//  TopView.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/02/12.
//

import SwiftUI

struct TopView: View {
    var body: some View {
      NavigationStack {
        List {
          Text("Hello World")
          Text("Hello World")
          Text("Hello World")
        }
        .navigationTitle("時間選択")
      }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
