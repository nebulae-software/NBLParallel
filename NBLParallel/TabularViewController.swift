//
//  TabularViewController.swift
//  NBLParallel
//
//  Created by Jorge Galrito on 03/01/2019.
//  Copyright © 2019 Nebulae Software. All rights reserved.
//

import UIKit

open class TabularViewController: UIViewController {
  
  fileprivate var titleSegmentsControl: ScrollableSegmentedControl = {
    let control = ScrollableSegmentedControl(titles: [], frame: .zero)
    return control
  }()
  
  private lazy var pageController: UIPageViewController! = {
    return UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal,
      options: nil
    )
  }()
  
  public var segmentedBarTintColor: UIColor? {
    get {
      return titleSegmentsControl.backgroundColor
    }
    set {
      titleSegmentsControl.backgroundColor = newValue
    }
  }
  
  public var font: UIFont {
    get {
      return titleSegmentsControl.buttonsFont
    }
    set {
      titleSegmentsControl.buttonsFont = newValue
    }
  }

  public var activeTitleColor: UIColor {
    get {
      return titleSegmentsControl.activeButtonsColor
    }
    set {
      titleSegmentsControl.activeButtonsColor = newValue
    }
  }
  
  public var inactiveTitleColor: UIColor {
    get {
      return titleSegmentsControl.inactiveButtonsColor
    }
    set {
      titleSegmentsControl.inactiveButtonsColor = newValue
    }
  }
  
  public var isGestureBasedNavigationEnabled: Bool {
    get {
      return pageController.dataSource != nil
    }
    set {
      if newValue {
        pageController.dataSource = self
      } else {
        pageController.dataSource = nil
      }
    }
  }
  
  public var selectedViewControllerIndex: Int = 0
  
  public var viewControllers: [UIViewController] = [] {
    didSet {
      titleSegmentsControl.titles = viewControllers.map { $0.title ?? " " }
      titleSegmentsControl.selectedIndex = 0
      
      if isViewLoaded {
        presentFirstViewController(animated: true)
      }
    }
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure page view controller

    pageController.dataSource = self
    pageController.delegate = self
    pageController.view.frame = view.bounds
    
    view.addSubview(pageController.view)
    self.addChild(pageController)
    pageController.didMove(toParent: self)
    
    if !viewControllers.isEmpty {
      presentFirstViewController(animated: false)
    }
    
    // Configure view controller titles navigator

    titleSegmentsControl.addTarget(
      self,
      action: #selector(titleSelected(_:)),
      for: .valueChanged
    )

    titleSegmentsControl.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleSegmentsControl)
    let constraints = [
      titleSegmentsControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      titleSegmentsControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      titleSegmentsControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    viewControllers.forEach {
      let additionalSafeAreaTopInset = titleSegmentsControl.frame.maxY - view.safeAreaInsets.top
      $0.additionalSafeAreaInsets = UIEdgeInsets(top: additionalSafeAreaTopInset, left: 0, bottom: 0, right: 0)
    }
  }
  
  private func presentFirstViewController(animated: Bool) {
    pageController.setViewControllers(
      [viewControllers[0]],
      direction: .forward,
      animated: animated,
      completion: { finished in
        self.selectedViewControllerIndex = 0
      }
    )
  }
  
  @objc private func titleSelected(_ sender: ScrollableSegmentedControl) {
    let currentIndex = titleSegmentsControl.selectedIndex
    let previousIndex = selectedViewControllerIndex
    
    let direction: UIPageViewController.NavigationDirection
    direction = previousIndex > currentIndex ? .reverse : .forward
    
    let nextViewController = viewControllers[currentIndex]
    pageController.setViewControllers(
      [nextViewController],
      direction: direction,
      animated: true,
      completion: { finished in
        self.selectedViewControllerIndex = currentIndex
      }
    )
  }
}

extension TabularViewController : UIPageViewControllerDelegate {
  public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    
    guard completed,
      let currentController = pageViewController.viewControllers?.first else {
        return
    }
    
    if let index = viewControllers.index(of: currentController) {
      titleSegmentsControl.selectedIndex = index
      selectedViewControllerIndex = index
    }
  }
}

extension TabularViewController : UIPageViewControllerDataSource {
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = viewControllers.index(of: viewController) else {
      return nil
    }
    
    let previousIndex = viewControllers.index(before: index)
    if previousIndex < viewControllers.startIndex {
      return nil
    }
    
    return viewControllers[previousIndex]
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = viewControllers.index(of: viewController) else {
      return nil
    }
    
    let nextIndex = viewControllers.index(after: index)
    if nextIndex >= viewControllers.endIndex {
      return nil
    }
    
    return viewControllers[nextIndex]
  }
}
