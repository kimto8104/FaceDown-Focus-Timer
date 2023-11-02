//
//  PageIntro.swift
//  NowFocus
//
//  Created by Tomofumi Kimura on 2023/05/27.
//

import SwiftUI

/// Page Intro Model

struct PageIntro: Identifiable, Hashable {
  var id: UUID = .init()
  var introAssetImage: String
  var title: String
  var subTitle: String
  
}

var pageIntros: [PageIntro] = [
  .init(introAssetImage: "study_man_normal", title: "Focus for yourself", subTitle: "test is important"),
  .init(introAssetImage: "study_man_normal", title: "Focus for yourself", subTitle: "test is important"),
  .init(introAssetImage: "study_man_normal", title: "Focus for yourself", subTitle: "test is important")
]
