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
    case threeD
    case saveTheDot
  }
  var animationType: BaseAnimationType = .basic
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configData = ["Basic", "Abstract Animations Away", "Running Animators", "Basic Keyframe", "Spring Timing Parameters", "Transition", "3D Animation", "Save The Dot"]
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
    case .threeD:
      threeDAnimation()
    case .saveTheDot:
      saveTheDotAnimation()
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
   m34: z轴的透视
   绕轴旋转的由anchorPoint 和 CATransform3DRotate 共同决定
   比如anchorPoint= (1.0, 1.0), 沿着y轴旋转180度，那么就在anchorPoint点处，画一条和y轴平行的线，也就是右侧边线，作为翻转用的轴线
   */
  func threeDAnimation() {
    storyImageLayer.backgroundColor = UIColor.blue.cgColor.copy(alpha: 0.8)
    var identity = CATransform3DIdentity
    identity.m34 = -1.0/2000 // 其中分母，建议取750~2000，有好的透视效果
    let originFrame = storyImageLayer.frame
    storyImageLayer.anchorPoint.x = 1.0 //调整锚点位置
    storyImageLayer.anchorPoint.y = 1.0
    storyImageLayer.frame = originFrame //anchorPoint会改变frame，所以需要重新复制originFrame
    self.storyImageLayer.transform = identity
    let animator = UIViewPropertyAnimator(duration: duration*4, curve: .linear)
    animator.addAnimations {
      self.storyImageLayer.transform = CATransform3DRotate(identity, .pi, 0.0, 1.0, 0.0)
    }
    animator.startAnimation()
  }
  
  func saveTheDotAnimation() {
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "SaveTheDotViewController") as! SaveTheDotViewController
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  
}
