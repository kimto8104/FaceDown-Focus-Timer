//
//  CustomAlert.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/11/17.
//

import SwiftUI

struct CustomAlert: View {
  @Binding var isPresented: Bool
    var body: some View {
      VStack(spacing: 8) {
        Image(systemName: "lightbulb.max.fill")
          .font(.title)
          .foregroundStyle(.white)
          .frame(width: 65, height: 65)
          .background {
            Circle()
              .fill(.red.gradient)
              .background {
                Circle()
                  .fill(.background)
                  .padding(-5)
              }
              
          }
        
        Text("時間について")
          .fontWeight(.semibold)
        
        Text("クリアするごと選択肢が増えていきます")
          .multilineTextAlignment(.center)
          .fontWeight(.bold)
          .padding(.top, 5)
        
        HStack(spacing: 10) {
          Button {
            
          } label: {
            Text("OK")
              .foregroundStyle(.white)
              .fontWeight(.semibold)
              .padding(.vertical, 10)
              .padding(.horizontal, 25)
              .background {
                RoundedRectangle(cornerRadius: 12)
                  .fill(.blue.gradient)
              }
          }
        }
      }
      .frame(width: 256)
      .padding([.horizontal, .bottom], 25)
      .background {
        RoundedRectangle(cornerRadius: 25)
          .fill(.background)
          .padding(.top, 25)
      }
    }
}

#Preview {
  // `isPresented`の状態を管理する`@State`変数を作成
  @Previewable @State var isPresented = true
  CustomAlert(isPresented: $isPresented)
}

