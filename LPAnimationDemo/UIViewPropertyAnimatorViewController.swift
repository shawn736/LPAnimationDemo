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
    case spring
    case transition
  }
  var animationType: BaseAnimationType = .basic
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configData = ["Basic", "Abstract Animations Away", "Running Animators", "Basic Keyframe", "Spring Timing Parameters", "Transition"]
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
    case .spring:
      springAnimation()
    case .transition:
      transitionAnimation()
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
  
  func springAnimation() {
    let spring = UISpringTimingParameters(mass: 1.0, stiffness: 100.0, damping: 1.0, initialVelocity: CGVector(dx: 0, dy: 0))
    let animator = UIViewPropertyAnimator(duration: duration, timingParameters: spring)
    animator.addAnimations {
      self.storyImageView.frame.origin.y += 100
    }
    
    
    animator.startAnimation()
  }
  
  func transitionAnimation() {
    let animator = UIViewPropertyAnimator(duration: duration*2, curve: .easeOut)
    let transition = {
      UIView.transition(with: self.storyImageView, duration: self.duration, options: .transitionCrossDissolve, animations: {
        self.storyImageView.image = UIImage(named: "plane")
      }, completion: nil)
    }
    
    animator.addAnimations(transition)
    animator.startAnimation()
    animator.pauseAnimation()
  }
  
  /*
   isRunning: read-only, 当调用startAnimation()后变为true, 如果pause或是stop，或者是自然完成动画，变为false
   isReversed: default false, 如果是true, 就逆向执行动画
   state:
   */
  
}
