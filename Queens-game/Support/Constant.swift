//
//  Constants.swift
//  Queens-game
//
//  Created by 杉原大貴 on 2021/05/10.
//

import Foundation
import UIKit

struct Constant {
  struct QueenSelection {
    static let options = [
      Selection(title: "Quick select", detail: "The queen is selected as you as you tap next", isSelected: true),
      Selection(title: "Card select", detail: "Those who select Queen will be the Queen!", isSelected: false)
    ]
    
    static let quickIndexPath: [IndexPath] = [[0, 0]]
    static let cardIndexPath: [IndexPath] = [[0, 1]]
    static let cardBottomSpacing: CGFloat = 112
  }
}
