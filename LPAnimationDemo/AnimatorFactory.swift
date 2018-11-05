//
//  AnimatorFactory.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/5.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit

class AnimatorFactory {
  static func scaleUp(view: UIView) -> UIViewPropertyAnimator {
    let scale = UIViewPropertyAnimator(duration: 1, curve: .easeIn)
    scale.addAnimations{
      view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    return scale
  }
  
  static func jiggle(view: UIView) {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.33, delay: 0, options: [], animations: {
      UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
          view.transform = CGAffineTransform(rotationAngle: -.pi/8)
        })
        
        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75, animations: {
          view.transform = CGAffineTransform(rotationAngle: +.pi/8)
        })
        
        UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1.0, animations: {
          view.transform = .identity
        })
        
      }, completion: { _ in
        view.transform = .identity
      })
    }, completion: { _ in
      
    })
  }
}
