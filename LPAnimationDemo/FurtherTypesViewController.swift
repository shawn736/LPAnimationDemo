//
//  FurtherTypesViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/5.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit

/// 最后一节，其他动画
class FurtherTypesViewController: BaseViewController {
  
  // 在屏幕上实时绘图的参数
  var lineBeizer: UIBezierPath?
  var lineStartPoint: CGPoint?
  var lineMovePoint: CGPoint?
  var lineShapeLayer: CAShapeLayer?

  enum BaseAnimationType: Int{
    case threeD
    case snow
    case imageView
    case fire
    case drawLineRealTime
    case drawLogLine
    case pauseAndResume
  }
  var animationType: BaseAnimationType = .threeD
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configData = ["3D Animation", "snow", "UIImageView", "Fire", "Draw Line Real Time", "Draw Log Line", "PauseAndResume"]
  }
  
  override func didSelectRowAt(indexPath: IndexPath) {
    animationType = BaseAnimationType.init(rawValue: indexPath.item) ?? .threeD
    setStoryImageView()
  }
  
  override func startAnimation() {
    switch animationType {
    case .threeD:
      threeDAnimation()
    case .snow:
      snowAnimation()
    case .imageView:
      imageViewAnimation()
    case .fire:
      fireAnimation()
    case .drawLineRealTime:
      drawLineRealTime()
    case .drawLogLine:
      drawLogLine()
    case .pauseAndResume:
      pauseAndResumeLayerAnimation()
    }
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
  
  func snowAnimation() {
    view.backgroundColor = .black
    let rect = CGRect(x: 0.0, y: -70.0, width: view.bounds.width, height: 50.0)
    let emitter = CAEmitterLayer()
    emitter.frame = rect
    view.layer.addSublayer(emitter)
    
    emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
    
    emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
    emitter.emitterSize = rect.size
    
    let emitterCell = CAEmitterCell()
    emitterCell.contents = UIImage(named: "flake.png")?.cgImage
    emitterCell.birthRate = 20
    emitterCell.lifetime = 3.5
    emitter.emitterCells = [emitterCell]
    emitterCell.yAcceleration = 70.0
    emitterCell.xAcceleration = 10.0
    emitterCell.velocity = 20.0
    emitterCell.emissionLongitude = .pi * -0.5
    emitterCell.velocityRange = 200.0
    emitterCell.emissionRange = .pi * 0.5
    emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    emitterCell.redRange   = 0.1
    emitterCell.greenRange = 0.1
    emitterCell.blueRange  = 0.1
    emitterCell.scale = 0.8
    emitterCell.scaleRange = 0.8
    emitterCell.scaleSpeed = -0.15
    emitterCell.birthRate = 150
    emitterCell.alphaRange = 0.75
    emitterCell.alphaSpeed = -0.15
    emitterCell.emissionLongitude = -.pi
    emitterCell.lifetimeRange = 1.0
    
    //cell #2
    let cell2 = CAEmitterCell()
    cell2.contents = UIImage(named: "flake2.png")?.cgImage
    cell2.birthRate = 50
    cell2.lifetime = 2.5
    cell2.lifetimeRange = 1.0
    cell2.yAcceleration = 50
    cell2.xAcceleration = 50
    cell2.velocity = 80
    cell2.emissionLongitude = .pi
    cell2.velocityRange = 20
    cell2.emissionRange = .pi * 0.25
    cell2.scale = 0.8
    cell2.scaleRange = 0.2
    cell2.scaleSpeed = -0.1
    cell2.alphaRange = 0.35
    cell2.alphaSpeed = -0.15
    cell2.spin = .pi
    cell2.spinRange = .pi
    
    //cell #3
    let cell3 = CAEmitterCell()
    cell3.contents = UIImage(named: "flake3.png")?.cgImage
    cell3.birthRate = 20
    cell3.lifetime = 7.5
    cell3.lifetimeRange = 1.0
    cell3.yAcceleration = 20
    cell3.xAcceleration = 10
    cell3.velocity = 40
    cell3.emissionLongitude = .pi
    cell3.velocityRange = 50
    cell3.emissionRange = .pi * 0.25
    cell3.scale = 0.8
    cell3.scaleRange = 0.2
    cell3.scaleSpeed = -0.05
    cell3.alphaRange = 0.5
    cell3.alphaSpeed = -0.05
    
    emitter.emitterCells = [emitterCell, cell2, cell3]
    
  }
  
  func imageViewAnimation() {
    let walkFrames = [
      UIImage(named: "walk01.png")!,
      UIImage(named: "walk02.png")!,
      UIImage(named: "walk03.png")!,
      UIImage(named: "walk04.png")!
    ]
    storyImageView.image = walkFrames[0]
    storyImageView.animationImages = walkFrames
    storyImageView.animationDuration = duration
    storyImageView.animationRepeatCount = 3
    storyImageView.startAnimating()
  
  }
  
  /*
   renderMode 渲染模式
   additive: 粒子混合,合并粒子重叠部分的亮度使其更加明亮
   */
  
  func fireAnimation() {
    view.backgroundColor = .black
    let emitter = CAEmitterLayer()
    emitter.frame = storyImageView.layer.bounds
    emitter.emitterPosition = CGPoint(x: storyImageView.frame.width * 0.5, y: storyImageView.frame.height)
    emitter.renderMode = .additive
    storyImageView.layer.addSublayer(emitter)
    
    let fire = CAEmitterCell()
    fire.birthRate = 400
    fire.lifetime = 2.0
    fire.lifetimeRange = 1.5
    fire.color = UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 0.1).cgColor
    fire.contents = UIImage(named: "fire_white")?.cgImage
    fire.velocity = 80
    fire.velocityRange = 80
    fire.emissionLongitude = .pi + .pi/2
    fire.emissionRange = .pi/2
    
    fire.scaleSpeed = 0.3
    fire.spin = 0.2
    
    let smoke = CAEmitterCell()
    smoke.birthRate = 200
    smoke.lifetime = 3.0
    smoke.lifetimeRange = 1.5
    smoke.color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.05).cgColor
    smoke.contents = UIImage(named: "smoke_white")?.cgImage
    
    smoke.velocity = 125
    smoke.velocityRange = 100
    smoke.emissionLongitude = .pi + .pi/2
    smoke.emissionRange = .pi
    
    emitter.emitterCells = [fire, smoke]
    
  }
  
  func initCAShaper() {
    lineBeizer = UIBezierPath()
    
    lineShapeLayer = CAShapeLayer()
    lineShapeLayer?.frame = CGRect(x: 0, y: 0, width: storyView.frame.width, height: storyView.frame.height)
    lineShapeLayer?.fillColor = UIColor.clear.cgColor
    lineShapeLayer?.lineCap = .round
    lineShapeLayer?.strokeColor = UIColor.cyan.cgColor
    lineShapeLayer?.lineWidth = 2
    storyView.layer.addSublayer(lineShapeLayer!)
  }
  
  func drawLineRealTime() {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(panTouch(pan:)))
    storyView.addGestureRecognizer(pan)
    initCAShaper()
  }
  
  func drawLogLine() {
    initCAShaper()
    lineShapeLayer?.strokeColor = UIColor.blue.cgColor
    let startPoint = CGPoint(x: 100, y: 300)
    lineBeizer?.move(to: startPoint)
    for i in 1...100 {
      let x: CGFloat = CGFloat(i)
      let y: CGFloat = log2(x)  //log2(x) , pow(2.0, (x)) <变化太快，x取值范围要很小的变化>
      let movePoint = CGPoint(x: startPoint.x + x, y: startPoint.y-y)
      lineBeizer?.addLine(to: movePoint)
    }
    lineShapeLayer?.path = lineBeizer?.cgPath
  }
  
  @objc func panTouch(pan: UIPanGestureRecognizer) {
    lineStartPoint = pan.location(in: storyView)
    if pan.state == .began {
      lineBeizer?.move(to: lineStartPoint!)
    }
    
    if pan.state == .changed {
      lineMovePoint = pan.location(in: storyView)
      lineBeizer?.addLine(to: lineMovePoint!)
      lineShapeLayer?.path = lineBeizer?.cgPath
    }
    
  }
  
  var isPause: Bool = false
  let button = UIButton()
  func pauseAndResumeLayerAnimation() {
    button.frame = CGRect(x: 100, y: 300, width: 50, height: 50)
    button.backgroundColor = .red
    button.setTitle("pause", for: .normal)
    button.addTarget(self, action: #selector(pauseOrResume), for: .touchUpInside)
    storyView.addSubview(button)
    
    let animation = CABasicAnimation(keyPath: "bounds")
    animation.toValue = CGRect(x: storyImageLayer.frame.minX, y: storyImageLayer.frame.minY, width: storyImageLayer.frame.width * 4.0, height: storyImageLayer.frame.height * 4.0)
    animation.duration = 10.0
    animation.delegate = self
//    animation.isRemovedOnCompletion = false //添加这个就可以在按home返回时继续动画，不过还是建议不要用这个字段
    //按home的动画暂停问题，是建议添加监听UIApplicationDidBecomeActiveNotification，重新开始动画
    NotificationCenter.default.addObserver(self, selector: #selector(enterFore(not:)), name: UIApplication.didBecomeActiveNotification, object: self)
    storyImageLayer.add(animation, forKey: "PauseAndResume")
 
  }
  
  @objc func enterFore(not: NSNotification) {
    pauseAndResumeLayerAnimation()
  }

  @objc func pauseOrResume() {
    if isPause {
      // 恢复
      let pausedTime = storyImageLayer.timeOffset
      storyImageLayer.speed = 1.0
      storyImageLayer.timeOffset = 0.0
      storyImageLayer.beginTime = 0.0
      let timeSinePause = storyImageLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
      storyImageLayer.beginTime = timeSinePause
      button.setTitle("pause", for: .normal)
    } else {
      // 暂停
      let pausedTime = storyImageLayer.convertTime(CACurrentMediaTime(), from: nil)
      storyImageLayer.speed = 0.0
      storyImageLayer.timeOffset = pausedTime
       button.setTitle("resume", for: .normal)
    }
    isPause = !isPause
  }

}

extension FurtherTypesViewController: CAAnimationDelegate {
  func animationDidStart(_ anim: CAAnimation) {
    
  }
  
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    print("animation: \(anim), flag: \(flag)")
  }
}
