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
  }
  var animationType: BaseAnimationType = .positionAndSize
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configData = ["Position And Size", "Border", "Shadow", "Contents", "Animations Keys & Delegate"]
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
  
  override func didSelectRowAt(indexPath: IndexPath) {
    animationType = BaseAnimationType.init(rawValue: indexPath.item) ?? .positionAndSize
    setStoryImageView()
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
