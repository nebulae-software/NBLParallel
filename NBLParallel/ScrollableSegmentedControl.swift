//
//  ScrollableSegmentedControl.swift
//  NBLParallel
//
//  Created by Jorge Galrito on 03/01/2019.
//  Copyright © 2019 Nebulae Software. All rights reserved.
//

import UIKit

class ScrollableSegmentedControl : UIControl {
  private let scrollView = UIScrollView()
  private let stackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    return stack
  }()
  
  var activeButtonsColor: UIColor = .white {
    didSet {
      buttons.forEach { $0.activeColor = activeButtonsColor }
    }
  }
  
  var inactiveButtonsColor: UIColor = .lightGray {
    didSet {
      buttons.forEach { $0.inactiveColor = inactiveButtonsColor }
    }
  }
  
  var buttonsFont = UIFont.preferredFont(forTextStyle: .body, compatibleWith: nil) {
    didSet {
      buttons.forEach { $0.titleLabel?.font = buttonsFont }
    }
  }
  
  override var backgroundColor: UIColor? {
    didSet {
      scrollView.backgroundColor = backgroundColor
    }
  }
  
  var titles: [String] = [] {
    didSet {
      configure()
    }
  }
  var buttons: [ScrollableSegmentedControlItemButton] = []
  var selectedButton: ScrollableSegmentedControlItemButton?
  
  var selectedIndex = 0 {
    didSet {
      selectButton(at: selectedIndex)
    }
  }
  
  init(titles: [String], frame: CGRect) {
    self.titles = titles
    super.init(frame: frame)
    configure()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }

  private func configure() {
    buildViews()
    selectButton(at: selectedIndex)
  }
  
  private func buildViews() {
    setUpScrollView()
    setupStackView()
    setUpButtons()
  }
  
  private func setUpScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    
    addSubview(scrollView)
    let constraints = [
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
      scrollView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
  private func setupStackView() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 10
    stackView.distribution = .equalSpacing
    stackView.alignment = .fill
    
    scrollView.addSubview(stackView)
    let constraints = [
      stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 10),
      stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10),
      scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
      scrollView.heightAnchor.constraint(equalToConstant: 50),
      stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
  private func setUpButtons() {
    titles.forEach { title in
      let button = ScrollableSegmentedControlItemButton()
      button.setTitle(title, for: .normal)
      button.titleLabel?.font = buttonsFont
      button.addTarget(self,
                       action: #selector(buttonClicked(button:)),
                       for: .touchUpInside)
      
      button.sizeToFit()
      buttons.append(button)
      stackView.addArrangedSubview(button)
    }
  }
  
  private func selectButton(at index: Int) {
    guard index <= buttons.count - 1 else {
      return
    }
    
    selectedButton?.isSelected = false
    selectedButton = buttons[index]
    selectedButton?.isSelected = true
    
    centerContentIfPossible()
  }
  
  @objc private func buttonClicked(button: ScrollableSegmentedControlItemButton) {
    selectedButton?.isSelected = false
    button.isSelected = true
    selectedIndex = buttons.index(of: button) ?? 0
    
    sendActions(for: .valueChanged)
  }
  
  private func centerContentIfPossible() {
    guard let selectedButton = selectedButton else {
      return
    }
    
    let convertedFrame = scrollView.convert(selectedButton.frame, from: selectedButton.superview!)
    let newFrame = CGRect(
      x: convertedFrame.minX,
      y: 0,
      width: scrollView.bounds.width,
      height: scrollView.bounds.height
    )
    scrollView.scrollRectToVisible(newFrame, animated: true)
  }
}
