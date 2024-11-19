//
//  FloatingBottomSheet.swift
//  FaceDown Focus Timer
//
//  Created by Tomofumi Kimura on 2024/11/18.
//

import SwiftUI

extension View {
  @ViewBuilder func floatingBottomSheet<Content: View>(
    isPresented: Binding<Bool>, onDismiss: @escaping () -> () = {}, @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
      content()
        .presentationCornerRadius(0)
        .presentationBackground(.clear)
        .presentationDragIndicator(.hidden)
    }
  }
}
