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
    case positionAndSize = 0 // bounds, frame, center
    case appearance // backgroudColor, alpha
    case transformation //transform
    case repeatingAndAutoreverse
    case easing
    case delayAndCompletion
    case springAndZeroVelocity
    case springAndVelocity
  }
  
  let configData = ["Position And Size", "Appearance", "Transformation", "Repeating And Autoreverse", "Easing", "Delay And Completion", "Spring And Zero Velocity", "Spring And Velocity"]
  let duration = 0.5
  var animationType: BaseAnimationType = .positionAndSize
  
  override func viewDidLoad() {
    super.viewDidLoad()
    leftTableView.delegate = self
    leftTableView.dataSource = self
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
      UIView.animate(withDuration: self.duration, delay: self.duration, options: [], animations: {
        self.storyImageView.center.y += 100
      }, completion: nil)
     
    })
  }
  
  func springAndZeroVelocityAnimation() {
    /*
     damping 阻尼值，0.0~1.0, 越小弹簧效果越明显
     velocity 初始速度，如果object动画前就是静止的，建议给0这样看起来更流畅。
     在保证duration总时长的前提下，damping越小，velocity越大，弹簧效果越明显
     */
    UIView.animate(withDuration: duration*10, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
      self.storyImageView.center.y += 300
    }, completion: nil)
  }
  
  func springAndVelocityAnimation() {
    /*
     damping 阻尼值，0.0~1.0, 越小弹簧效果越明显
     velocity 初始速度，如果object动画前就是静止的，建议给0这样看起来更流畅。
     在保证duration总时长的前提下，damping越小，velocity越大，弹簧效果越明显
     */
    UIView.animate(withDuration: duration*10, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
      self.storyImageView.center.y += 300
    }, completion: nil)
  }
  
}

extension ViewAnimationViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return configData.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
    let label = cell.viewWithTag(10) as! UILabel
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = configData[indexPath.item]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    animationType = BaseAnimationType.init(rawValue: indexPath.item) ?? .positionAndSize
    setStoryImageView()
  }
  
}


