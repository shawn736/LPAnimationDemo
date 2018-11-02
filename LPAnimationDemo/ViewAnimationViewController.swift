//
//  ViewAnimationViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/2.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit

class ViewAnimationViewController: BaseViewController {
  
  enum BaseAnimationType: Int{
    case positionAndSize
    case appearance
    case transformation
    case repeatingAndAutoreverse
    case easing
    case delayAndCompletion
    case springAndZeroVelocity
    case springAndVelocity
    case hideTransition
    case repalceTransition
    case keyFrame
    case autoLayout
  }
  
  var animationType: BaseAnimationType = .positionAndSize
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configData = ["Position And Size", "Appearance", "Transformation", "Repeating And Autoreverse", "Easing", "Delay And Completion", "Spring And Zero Velocity", "Spring And Velocity", "Hide Transition", "Repalce Transition", "Key Frame", "Auto Layout"]
  }

  override func startAnimation() {
    switch animationType {
    case .positionAndSize:
      positionAndSizeAnimation()
    case .appearance:
      appearanceAnimation()
    case .transformation:
      transformationAnimation()
    case .repeatingAndAutoreverse:
      repeatingAndAutoreverseAnimation()
    case .easing:
      easingAnimation()
    case .delayAndCompletion:
      delayAndCompletionAnimation()
    case .springAndZeroVelocity:
      springAndZeroVelocityAnimation()
    case .springAndVelocity:
      springAndVelocityAnimation()
    case .hideTransition:
      hideTransitionAnimation()
    case .repalceTransition:
      replaceTransitionAnimation()
    case .keyFrame:
      keyFrameAnimation()
    case .autoLayout:
      autoLayoutAnimation()
    }
    
  }
  
  func positionAndSizeAnimation() {
    UIView.animate(withDuration: duration) {
      self.storyImageView.bounds.size.width *= 1.2
      self.storyImageView.center.x += 80
      self.storyImageView.center.y += 100
      self.storyImageView.frame.size.height *= 1.5
    }
  }
  
  func appearanceAnimation() {
    UIView.animate(withDuration: duration) {
      self.storyImageView.backgroundColor = .blue
      self.storyImageView.alpha = 0.5
    }
  }
  
  func transformationAnimation() {
    UIView.animate(withDuration: duration*1.5) {
      let rotation = CGAffineTransform(rotationAngle: .pi/2)
      let scale = CGAffineTransform(scaleX: 1.2, y: 1.5)
      let position = CGAffineTransform(translationX: 80, y: 200)
      self.storyImageView.transform = rotation.concatenating(scale).concatenating(position) // concatenating 把两个transform组合起来
    }
  }
  
  func repeatingAndAutoreverseAnimation() {
    UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .autoreverse], animations: {
      self.storyImageView.center.y += 200
    }, completion: nil)
  }
  
  func easingAnimation() {
    /*
     curveLinear 全程匀速
     curveEaseIn 前段加速后匀速
     curveEaseOut 先匀速后段减速
     curveEaseInOut 前段加速＋匀速+后段减速
    */
    UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .autoreverse, .curveEaseOut], animations: {
      self.storyImageView.center.y += 200
    }, completion: nil)
  }
  
  func delayAndCompletionAnimation() {
    UIView.animate(withDuration: duration, animations: {
      self.storyImageView.center.x += 80
    }, completion: { _ in
      // 延迟1秒后执行动画
      UIView.animate(withDuration: self.duration, delay: 1, options: [], animations: {
        self.storyImageView.center.y += 100
      }, completion: nil)
     
    })
  }
  
  func springAndZeroVelocityAnimation() {
    /*
     damping 阻尼值，0.0~1.0, 越小弹簧效果越明显
     velocity 初始速度，如果object动画前就是静止的，建议给0这样看起来更流畅。
     在保证duration总时长的前提下，damping越小，velocity越大，弹簧效果越明显
     不仅对位置/大小，对颜色/透明度等都会有弹簧效果
     */
    UIView.animate(withDuration: duration*10, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
      self.storyImageView.center.y += 300
      self.storyImageView.alpha = 0.3
    }, completion: nil)
  }
  
  func springAndVelocityAnimation() {
    UIView.animate(withDuration: duration*10, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
      self.storyImageView.center.y += 300
      self.storyImageView.alpha = 0.3
    }, completion: nil)
  }
  
  func hideTransitionAnimation() {
    /*
     transitionFlipFromLeft   左半边往外面，右半边向里面，沿着垂直的中间轴翻转
     transitionFlipFromRight   右半边往外面，左半边向里面，沿着垂直的中间轴翻转
     transitionCurlUp  向上翻页
     transitionCurlDown 向下翻页
     transitionCrossDissolve 交叉消失和显示，从一个视图到另一个视图的过度（注：单个视图没有效果）
     transitionFlipFromTop  上半边往外面，下半边向里面，沿着垂直的水平轴翻转
     transitionFlipFromBottom  下半边往外面，上半边向里面，沿着垂直的水平轴翻转
     */
    UIView.transition(with: storyImageView, duration: duration, options: .transitionFlipFromBottom, animations: {
      self.storyImageView.alpha = 0
    }, completion: nil)
  }
  
  func replaceTransitionAnimation() {
    let newView = UIView.init(frame: storyImageView.frame)
    newView.backgroundColor = .green
    storyImageView.addSubview(newView)
    UIView.transition(from: storyImageView, to: newView, duration: duration*4, options: .transitionCrossDissolve, completion: nil)
  }
  
  func keyFrameAnimation() {
    /*
     relativeStartTime 开始的时间点，总时长的百分比，比如是0.5，那么就是中间时间点开始执行
     relativeDuration 持续的时长，也是总时长的百分比，比如是0.25，表示持续总时长的25%
     */
    UIView.animateKeyframes(withDuration: duration*4, delay: 0, options: [], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.35, animations: {
        self.storyImageView.center.x += 100
        self.storyImageView.center.y += 100
      })
      UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4, animations: {
        self.storyImageView.transform = CGAffineTransform(rotationAngle: .pi/8)
      })
      
      UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
        self.storyImageView.center.x += 100
        self.storyImageView.center.y += 60
        self.storyImageView.alpha = 0.0
      })
      UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01, animations: {
        self.storyImageView.transform = .identity
        self.storyImageView.frame.origin.x = self.initialStoryImageViewFrame.minX
      })
      UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45, animations: {
        self.storyImageView.alpha = 1.0
        self.storyImageView.frame.origin.y = self.initialStoryImageViewFrame.minY
      })
    }, completion: nil)
  }
  
  func autoLayoutAnimation() {
    UIView.animate(withDuration: duration) {
      // 设置新的约束
      self.storyImageView.snp.makeConstraints { (make) in
        make.left.equalTo(100)
        make.top.equalTo(150)
        make.width.equalTo(self.initialStoryImageViewFrame.width*1.5)
        make.height.equalTo(self.initialStoryImageViewFrame.height*1.5)
      }
      self.view.layoutIfNeeded() // 立即更新布局
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    animationType = BaseAnimationType.init(rawValue: indexPath.item) ?? .positionAndSize
    setStoryImageView()
  }
}


