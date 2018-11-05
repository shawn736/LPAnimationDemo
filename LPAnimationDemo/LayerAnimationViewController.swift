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
    case animationsKeysAndDelegate
    case groupsAndAdvancedTiming
    case repeatAndSpeed
    case spring
    case keyframeAnimation
  }
  var animationType: BaseAnimationType = .positionAndSize
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configData = ["Position And Size", "Border", "Shadow", "Contents", "Animations Keys & Delegate", "Groups & Advanced Timing", "Repeat & Speed", "Spring", "Keyframe Animation"]
  }
  
  override func didSelectRowAt(indexPath: IndexPath) {
    animationType = BaseAnimationType.init(rawValue: indexPath.item) ?? .positionAndSize
    setStoryImageView()
  }
  
  override func startAnimation() {
    switch animationType {
    case .positionAndSize:
      positionAndSizeAnimation()
    case .border:
      borderAnimation()
    case .shadow:
      shadowAnimation()
    case .contents:
      contentsAnimation()
    case .animationsKeysAndDelegate:
      animationsKeysAndDelegateAnimation()
    case .groupsAndAdvancedTiming:
      groupsAndAdvancedTimingAnimation()
    case .repeatAndSpeed:
      repeatAndSpeedAnimation()
    case .spring:
      springAnimation()
    case .keyframeAnimation:
      keyframeAnimation()
    }
  }
  
  /*
   layer 的属性有三个概念：original value - 添加动画前的属性值; from value - 动画的初始值; to value - 动画的结束值.
   fillMode的值会影响到layer在动画前和动画后的行为，有4中可设置的属性值：
   kCAFillModeRemoved ：begin 以前一直是original value, 动画开始时属性值立马切换到from value, 然后动画变化到 to value, 动画结束时属性值又立马切换到original value. (original value 和 from value 值不同时，可以明显看出来)
   kCAFillModeBackwards：动画前就切换到from value了，延迟几秒执行动画可以明显看出效果
   kCAFillModeForwards：动画结束后一直保持在to value, 起作用前提是removedOnCompletion设置为false
   kCAFillModeBoth：动画前就切换到from value, 动画后一直保持在to value, 起作用前提是removedOnCompletion设置为false
   */
  
  func positionAndSizeAnimation() {
    /*
     bounds
     position
     transform
     */
    let animator = CABasicAnimation(keyPath: "position.y")
    animator.fromValue = storyImageLayer.position.y - 100
    animator.toValue = storyImageLayer.position.y + 400
    animator.beginTime = CACurrentMediaTime() + 2 // 把动画延迟 2秒执行
    animator.duration = duration*4
    animator.fillMode = .backwards
    storyImageLayer.add(animator, forKey: nil)
  
  }
  
  func borderAnimation() {
    /*
     borderColor
     borderWidth
     cornerRadius
     */
    storyImageLayer.borderColor = UIColor.blue.cgColor
    let animator = CABasicAnimation(keyPath: "borderWidth")
    animator.fromValue = 0.0
    animator.toValue = 10.0
    animator.duration = duration*4
    // 方案一，以下保持动画结束时的状态，如果没加默认是还是动画开始前的状态
    animator.fillMode = .forwards
    animator.isRemovedOnCompletion = false
    
    storyImageLayer.add(animator, forKey: nil)
//    storyImageLayer.borderWidth = 10.0 // 方案二，这里相当于在动画开始前就调整了状态，即修改了original value，这样动画结束后就是想要的结果
  }
  
  func shadowAnimation() {
    /*
     shadowOffset
     shadowOpacity
     shadowPath
     shadowRadius
     */
    storyImageLayer.shadowOpacity = 1.0
    storyImageLayer.shadowColor = UIColor.gray.cgColor
    let animator = CABasicAnimation(keyPath: "shadowOffset")
    animator.fromValue = CGSize(width: 0, height: 0)
    animator.toValue = CGSize(width: 20, height: 20)
    animator.duration = duration*4
    animator.fillMode = .forwards
    animator.isRemovedOnCompletion = false
    storyImageLayer.add(animator, forKey: nil)
  }
  
  func contentsAnimation() {
    /*
     contents
     mask
     opacity
     */
    let animator = CABasicAnimation(keyPath: "contents")
    animator.toValue = UIImage(named: "plane")?.cgImage
    animator.duration = duration*4
    animator.fillMode = .forwards
    animator.isRemovedOnCompletion = false
    storyImageLayer.add(animator, forKey: nil)
  }
  
  func animationsKeysAndDelegateAnimation() {
    // 先放大到1.25倍，通过delegate，缩小到0.5倍
    let animator = CABasicAnimation(keyPath: "transform.scale")
    animator.toValue = 1.25
    animator.duration = duration*4
    animator.fillMode = .forwards
    animator.isRemovedOnCompletion = false
    animator.setValue("scale", forKey: "name")
    animator.delegate = self
    
    storyImageLayer.add(animator, forKey: "scaleAnimator")   //设置指定的key, 需要移除指定的动画时，就可以通过storyImageLayer.removeAnimation(forKey: "scaleAnimator")；  移除所有的动画 storyImageLayer.removeAllAnimations()

  }
  /*
   CAMediaTimingFunction
   linear - 匀速
   easeIn - 前段加速
   easeOut - 后段减速
   easeInEaseOut - 前段加速+后段减速
   */
  func groupsAndAdvancedTimingAnimation() {
    let groupAnimation = CAAnimationGroup()
    groupAnimation.beginTime = CACurrentMediaTime() + 0.5
    groupAnimation.duration = duration
    groupAnimation.fillMode = .backwards
    
    let scaleDown = CABasicAnimation(keyPath: "transform.scale")
    scaleDown.fromValue = 3.5
    scaleDown.toValue = 1.0
    
    let rotate = CABasicAnimation(keyPath: "transform.rotation")
    rotate.fromValue = .pi/4.0
    rotate.toValue = 0.0
    
    let fade = CABasicAnimation(keyPath: "opacity")
    fade.fromValue = 0.0
    fade.toValue = 1.0
    
    groupAnimation.animations = [scaleDown, rotate, fade]
    groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
    storyImageLayer.add(groupAnimation, forKey: nil)
  }
  
  func repeatAndSpeedAnimation() {
    let animator = CABasicAnimation(keyPath: "position.y")
    animator.toValue = storyImageLayer.position.y + 400
    animator.duration = duration*4
    animator.repeatCount = 4
    animator.autoreverses = true
    animator.speed = 5.0 // 几倍速
    storyImageLayer.add(animator, forKey: nil)
  }
  
  /*
   damping: 阻尼系数，越大停止越快, default: 10
   mass: 质量，影响运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大， default: 1
   stiffness: 刚度系数，越大，形变产生的力越大，运动越快, default: 100
   initial velocity: 初始速度， 速率为负，速度方向和运动方向相反, default: 0
   settlingDuration: 估算时间，弹簧开始到停止的时间，通过上面的参数估算出来
   */
  
  func springAnimation() {
    let animator = CASpringAnimation(keyPath: "transform.scale")
    animator.fromValue = 1.25
    animator.toValue = 1.0
    animator.damping = 1.0
//    animator.mass = 1.0
    animator.stiffness = 100.0
//    animator.initialVelocity = 0.0
    animator.duration = animator.settlingDuration
    storyImageLayer.add(animator, forKey: "scaleAnimator")
  }
  
  func keyframeAnimation() {
    let animator = CAKeyframeAnimation(keyPath: "position")
    animator.duration = duration * 4
    animator.values = [
      CGPoint(x: storyImageLayer.position.x, y: storyImageLayer.position.y),
      CGPoint(x: storyImageLayer.position.x + 80.0, y: storyImageLayer.position.y),
      CGPoint(x: storyImageLayer.position.x + 30.0, y: storyImageLayer.position.y + 100.0),
      CGPoint(x: storyImageLayer.position.x, y: storyImageLayer.position.y)
      ].map{ NSValue(cgPoint: $0)}
    animator.keyTimes = [0.0, 0.25, 0.5, 1.0]
    storyImageLayer.add(animator, forKey: nil)
  }
  
  
}

extension LayerAnimationViewController: CAAnimationDelegate {
  func animationDidStart(_ anim: CAAnimation) {
    
  }
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag {
      if let name = anim.value(forKey: "name") as? String, name == "scale" {
        let animator = CABasicAnimation(keyPath: "transform.scale")
        animator.toValue = 0.5
        animator.duration = duration
        animator.fillMode = .forwards
        animator.isRemovedOnCompletion = false
        storyImageLayer.add(animator, forKey: nil)
      }
    }
  }
}
