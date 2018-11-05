//
//  FurtherTypesViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/5.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit

/// 最后一节，其他
class FurtherTypesViewController: BaseViewController {

  enum BaseAnimationType: Int{
    case basic
  }
  var animationType: BaseAnimationType = .basic
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configData = ["Basic"]
  }
  
  override func didSelectRowAt(indexPath: IndexPath) {
    animationType = BaseAnimationType.init(rawValue: indexPath.item) ?? .basic
    setStoryImageView()
  }
  
  override func startAnimation() {
    switch animationType {
    case .basic:
      basicAnimation()
    }
  }
  
  
  func basicAnimation() {
    
  }

}
