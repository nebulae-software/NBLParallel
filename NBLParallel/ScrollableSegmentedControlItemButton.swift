//
//  ScrollableSegmentedControlItemButton.swift
//  NBLParallel
//
//  Created by Jorge Galrito on 03/01/2019.
//  Copyright © 2019 Nebulae Software. All rights reserved.
//

import UIKit

class ScrollableSegmentedControlItemButton: UIButton {
  
  var activeColor: UIColor = .white
  var inactiveColor: UIColor = .white
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  
  private func configure() {
    backgroundColor = .clear
    layer.cornerRadius = 5
    layer.masksToBounds = true
    contentEdgeInsets = UIEdgeInsets(top: 2, left: 15, bottom: 2, right: 15)
  }
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        layer.borderColor = activeColor.cgColor
        layer.borderWidth = 1
      } else {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
      }
    }
  }
}
