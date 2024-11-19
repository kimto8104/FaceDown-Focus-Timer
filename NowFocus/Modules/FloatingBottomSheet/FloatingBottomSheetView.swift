//
//  FloatingBottomSheetView.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/11/18.
//

import SwiftUI

struct FloatingBottomSheetView: View {
  var title: String
  var content: String
  var image: Config
  var button1: Config
  var button2: Config?
  var button1Action: () -> Void
  var button2Action: (() -> Void)?
  
    var body: some View {
      VStack(spacing: 15) {
        Image(systemName: "lightbulb.max.fill")
          .font(.title)
          .foregroundStyle(image.foreground)
          .frame(width: 65, height: 65)
          .background(image.tint.gradient, in: .circle)
        
        Text(title)
          .font(.title3.bold())
        
        Text(content)
          .font(.callout)
          .multilineTextAlignment(.center)
          .lineLimit(2)
          .foregroundStyle(.gray)
        
        ButtonView(button1, action: button1Action)
        if let button2 {
          ButtonView(button2, action: button2Action ?? {})
        }
      }
      .padding([.horizontal, .bottom], 15)
      .background {
        RoundedRectangle(cornerRadius: 15)
          .fill(.background)
          .padding(.top, 30)
      }
      .shadow(color: .black.opacity(0.12), radius: 8)
      .padding(.horizontal, 15)
    }
  
  @ViewBuilder func ButtonView(_ config: Config, action: @escaping () -> Void) -> some View {
    Button {
      action()
    } label: {
      Text(config.content)
        .fontWeight(.bold)
        .foregroundStyle(config.foreground)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(config.tint.gradient, in: .rect(cornerRadius: 10))
    }

  }
  
  struct Config {
    var content: String
    var tint: Color
    var foreground: Color
  }
}

#Preview {
  @Previewable var sheetView = FloatingBottomSheetView(title: "Test", content: "test test test", image: .init(content: "lightbulb.max.fill", tint: .red, foreground: .white), button1: .init(content: "Close", tint: .black, foreground: .white), button1Action: {})
  sheetView
}
