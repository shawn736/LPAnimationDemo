//
//  UIViewPropertyAnimatorViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/5.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit

/// UIViewPropertyAnimator, iOS10 以上支持
class UIViewPropertyAnimatorViewController: BaseViewController {
  enum BaseAnimationType: Int{
    case basic
    case abstractAway
    case running
    case keyframe
  }
  var animationType: BaseAnimationType = .basic
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configData = ["Basic", "Abstract Animations Away", "Running Animators", "Basic Keyframe"]
  }
  
  override func didSelectRowAt(indexPath: IndexPath) {
    animationType = BaseAnimationType.init(rawValue: indexPath.item) ?? .basic
    setStoryImageView()
  }

  override func startAnimation() {
    switch animationType {
    case .basic:
      basicAnimation()
    case .abstractAway:
      abstractAwayAnimation()
    case .running:
      runningAnimation()
    case .keyframe:
      keyframeAnimation()
    }
  }
  
  
  func basicAnimation() {
    let scale = UIViewPropertyAnimator(duration: 1, curve: .easeIn)
    scale.addAnimations{
      self.storyImageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
    }
    scale.addAnimations({
      self.storyImageView.alpha = 0.0
    }, delayFactor: 0.2) // 表示从 0.2 * duration  = 0.2 * 1 = 0.2, 即从动画开始0.2s后执行
    scale.addCompletion{ _ in
      self.storyImageView.alpha = 1.0
      self.storyImageView.transform = .identity
    }
    scale.startAnimation()
  }
  
  func abstractAwayAnimation() {
    AnimatorFactory.scaleUp(view: storyImageView).startAnimation()
  }
  
  func runningAnimation() {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
      self.storyImageView.alpha = 0
    }, completion: nil)
  }
  
  func keyframeAnimation() {
    AnimatorFactory.jiggle(view: storyImageView)
  }
  
}
