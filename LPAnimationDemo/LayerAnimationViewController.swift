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
  var animationType: BaseAnimationType = .positionAndSize
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configData = ["Position And Size", "Border", "Shadow", "Contents"]
  }
  
  override func startAnimation() {
    switch animationType {
    case .positionAndSize:
      positionAndSizeAnimation()
    default:
      positionAndSizeAnimation()
    }
  }
  
  func positionAndSizeAnimation() {
    /*
     */
    let animator = CABasicAnimation(keyPath: "position.y")
    animator.toValue = storyImageLayer.frame.minY + 100
    animator.duration = duration
    storyImageLayer.add(animator, forKey: nil)
  
  }
  
  override func didSelectRowAt(indexPath: IndexPath) {
    animationType = BaseAnimationType.init(rawValue: indexPath.item) ?? .positionAndSize
    setStoryImageView()
  }
  
  
}
