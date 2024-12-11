//
//  TimeSelectionView.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/02/12.
//

import SwiftUI

struct TimeSelectionView: View {
  @ObservedObject var presenter:TimeSelectionPresenter
  var body: some View {
    NavigationStack {
      GeometryReader { geometry in
        let hm = geometry.size.width / 375
        let vm = geometry.size.height / 667
        let multiplier = abs(hm - 1) < abs(vm - 1) ? hm : vm
        gradientBackground(gp: geometry, multiplier: multiplier)
        List {
          ForEach (presenter.timeOptions, id: \.self) { time in
            HStack {
              Spacer()
              TimeOptionCell(time: time)
                .padding(.vertical, 23 * multiplier) // セル間のスペース（46 / 2）
              Spacer()
            }
            // Listの背景色を透明に
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden) // セル間の線を非表示
          }
        }
        .scrollDisabled(true)
        .listStyle(PlainListStyle()) // スタイルを明示的に設定
        .padding(.top, 86 * multiplier)
        .onAppear(perform: {
          presenter.setupTimeOptions()
          presenter.checkFloatingSheetStatus()
        })
      }
    }
    .floatingBottomSheet(isPresented: $presenter.shouldShowFloatingBottomSheet) {
      FloatingBottomSheetView(title: "時間について", content: "時間はクリアするごとに増えます。そして毎日リセットされます", image: .init(content: "lightbulb.max.fill", tint: .red, foreground: .white), button1: .init(content: "Close", tint: .red, foreground: .white), button1Action: {
        // Close Sheet
        presenter.updateShouldShowFloatingBottomSheets(false)
      })
      .presentationDetents([.height(280)])
    }
  }
}

// MARK: Private
private extension TimeSelectionView {
  func gradientBackground(gp: GeometryProxy, multiplier: CGFloat) -> some View {
    LinearGradient(
      gradient: Gradient(stops: [
        .init(color: Color(hex: "#E7E4E4") ?? .clear, location: 0.0 * multiplier),
        .init(color: Color(hex: "#D5D0D0") ?? .clear, location: 0.53 * multiplier),
        .init(color: (Color(hex: "#DAD2D2") ?? .clear).opacity(0.81), location: 0.62 * multiplier),
        .init(color: (Color(hex: "#B6B0B0") ?? .clear).opacity(0.72), location: 1.0 * multiplier)
      ]),
      startPoint: .top,
      endPoint: .bottom
    )
    .opacity(0.77)
    .ignoresSafeArea() // 全画面に背景を適用
    .frame(width: gp.size.width, height: gp.size.height)
  }
}

struct TimeOptionCell: View {
  let time: Int
  @State private var isPressed = false
  @State private var navigate: Bool = false
  var body: some View {
    ZStack {
      // NavigationLinkのvalueにOptional Intを使用
      NavigationLink(destination:  TimerRouter.initializeTimerModule(with: time), isActive: $navigate, label: {
        EmptyView()
      })
      .opacity(0)
      
      Text("\(time) 分")
        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 4)
        .frame(width: 176, height: 60)
        .background(isPressed ? Color.gray : Color(hex: "#E3DDDD"))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 10, y: 10)
        .font(.custom("IBM Plex Mono", size: 20))
        .foregroundColor(.black)
        .multilineTextAlignment(.center)
        .shadow(color: Color(hex: "#FDF3F3")?.opacity(0.25) ?? .clear, radius: 4, x: -4, y: -4)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
        .onTapGesture {
          isPressed = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isPressed = false
            navigate = true // 遷移先の値を設定
          }
        }
    }
    .buttonStyle(PlainButtonStyle()) // 見た目をそのまま
  }
}

struct TimeOptionCellButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .background(configuration.isPressed ? Color.yellow : Color(hex: "#E3DDDD"))
      .cornerRadius(10)
      .shadow(color: Color.black.opacity(0.2), radius: 4, x: 10, y: 10)
      .shadow(color: Color(hex: "#FDF3F3")?.opacity(0.25) ?? .clear, radius: 4, x: -4, y: -4)
  }
}

struct TimeSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    TimeSelectionView(presenter: TimeSelectionPresenter())
  }
}
