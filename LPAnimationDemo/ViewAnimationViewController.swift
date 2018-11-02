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
  }
  
  let configData = ["Position And Size", "Appearance", "Transformation"]
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
    UIView.animate(withDuration: duration) {
      let rotation = CGAffineTransform(rotationAngle: .pi/2)
      let scale = CGAffineTransform(scaleX: 1.2, y: 1.5)
      let position = CGAffineTransform(translationX: 80, y: 100)
      self.storyImageView.transform = rotation.concatenating(scale).concatenating(position) // concatenating 把两个transform组合起来
    }
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


