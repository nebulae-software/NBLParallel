//
//  ScrollableSegmentedControlItemButton.swift
//  NBLParallel
//
//  Created by Jorge Galrito on 03/01/2019.
//  Copyright © 2019 Nebulae Software. All rights reserved.
//

import UIKit

class ScrollableSegmentedControlItemButton: UIButton {
  
  enum SelectionStyle {
    case border
    case lineBelow
  }
  
  var activeColor: UIColor = .white
  var inactiveColor: UIColor = .white
  
  var selectionStyle: SelectionStyle = .lineBelow
  
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
    contentEdgeInsets = UIEdgeInsets(top: 2, left: 15, bottom: 2, right: 15)
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let context = UIGraphicsGetCurrentContext()!
    context.saveGState()
    
    context.setLineWidth(5)
    context.setStrokeColor(UIColor.white.cgColor)
    
    let titleRect = self.titleRect(forContentRect: bounds)

    if isSelected {
      switch selectionStyle {
      case .border:
        let path = UIBezierPath(
          roundedRect: titleRect.insetBy(dx: -7, dy: -7),
          byRoundingCorners: .allCorners,
          cornerRadii: CGSize(width: 5, height: 5)
        )
        path.stroke()
        
      case .lineBelow:
        context.move(to: CGPoint(x: titleRect.minX, y: bounds.maxY - (5.0 / 2)))
        context.addLine(to: CGPoint(x: titleRect.maxX, y: bounds.maxY - (5.0 / 2)))
        context.drawPath(using: .stroke)
      }
    }
    
    context.restoreGState()
  }
}

extension CACornerMask {
  static var all: CACornerMask {
    return [CACornerMask.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
  }
}
