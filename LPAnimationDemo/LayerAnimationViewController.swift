//
//  LayerAnimationViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/2.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit

class LayerAnimationViewController: BaseViewController {
  enum BaseAnimationType: Int{
    case positionAndSize
    case border
    case shadow
    case contents
  }
  
  let configData = ["Position And Size", "Border", "Shadow", "Contents"]
  var animationType: BaseAnimationType = .positionAndSize

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
