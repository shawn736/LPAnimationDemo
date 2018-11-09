//
//  FirstWorldViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/9.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit
///UIViewPropertyAnimator的例子
class ZeroWorldViewController: UIViewController {
  // MARK: - enum
  fileprivate enum ScreenEdge: Int {
    case top = 0
    case right = 1
    case bottom = 2
    case left = 3
  }
  
  fileprivate enum ZeroWorldState {
    case ready
    case playing
    case collectOver
  }
  
  // MARK: - Constants
  fileprivate let radius: CGFloat = 10
  fileprivate let collectorAnimationDuration = 5.0
  fileprivate let dotSpeed: CGFloat = 60 // points per second
  fileprivate let colors = [#colorLiteral(red: 0.08235294118, green: 0.6980392157, blue: 0.5411764706, alpha: 1), #colorLiteral(red: 0.07058823529, green: 0.5725490196, blue: 0.4470588235, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.7333333333, blue: 0, alpha: 1), #colorLiteral(red: 0.9411764706, green: 0.5450980392, blue: 0, alpha: 1), #colorLiteral(red: 0.1411764706, green: 0.7803921569, blue: 0.3529411765, alpha: 1), #colorLiteral(red: 0.1176470588, green: 0.6431372549, blue: 0.2941176471, alpha: 1), #colorLiteral(red: 0.8784313725, green: 0.4156862745, blue: 0.03921568627, alpha: 1), #colorLiteral(red: 0.7882352941, green: 0.2470588235, blue: 0, alpha: 1), #colorLiteral(red: 0.1490196078, green: 0.5098039216, blue: 0.8352941176, alpha: 1), #colorLiteral(red: 0.1137254902, green: 0.4156862745, blue: 0.6784313725, alpha: 1), #colorLiteral(red: 0.8823529412, green: 0.2, blue: 0.1607843137, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.1411764706, blue: 0.1098039216, alpha: 1), #colorLiteral(red: 0.537254902, green: 0.2352941176, blue: 0.662745098, alpha: 1), #colorLiteral(red: 0.4823529412, green: 0.1490196078, blue: 0.6235294118, alpha: 1), #colorLiteral(red: 0.6862745098, green: 0.7137254902, blue: 0.7333333333, alpha: 1), #colorLiteral(red: 0.1529411765, green: 0.2196078431, blue: 0.2980392157, alpha: 1), #colorLiteral(red: 0.1294117647, green: 0.1843137255, blue: 0.2470588235, alpha: 1), #colorLiteral(red: 0.5137254902, green: 0.5843137255, blue: 0.5843137255, alpha: 1), #colorLiteral(red: 0.4235294118, green: 0.4745098039, blue: 0.4784313725, alpha: 1)]
  
  // MARK: - fileprivate
  fileprivate var collectorView = UIView(frame: .zero)
  fileprivate var collectorAnimator: UIViewPropertyAnimator?
  
  fileprivate var dotViews = [UIView]()
  fileprivate var dotAnimators = [UIViewPropertyAnimator]()
  fileprivate var dotTimer: Timer?
  
  fileprivate var displayLink: CADisplayLink?
  fileprivate var beginTimestamp: TimeInterval = 0
  fileprivate var elapsedTime: TimeInterval = 0
  
  fileprivate var zeroWorldState: ZeroWorldState = .ready
  
  // MARK: - IBOutlets
  @IBOutlet weak var clockLabel: UILabel!
  @IBOutlet weak var startLabel: UILabel!
  @IBOutlet weak var bestTimeLabel: UILabel!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectorView()
    prepareCollect()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // First touch to start the game
    if zeroWorldState == .ready {
      startCollect()
    }
    
    if let touchLocation = event?.allTouches?.first?.location(in: view) {
      // Move the collector to the new position
      moveCollector(to: touchLocation)
      
      // Move all enemies to the new position to trace the collector
      moveDots(to: touchLocation)
    }
  }
  
  // MARK: - Selectors
  @objc func generateDot(timer: Timer) {
    // Generate an enemy with random position
    let screenEdge = ScreenEdge.init(rawValue: Int(arc4random_uniform(4)))
    let screenBounds = UIScreen.main.bounds
    var position: CGFloat = 0
    
    switch screenEdge! {
    case .left, .right:
      position = CGFloat(arc4random_uniform(UInt32(screenBounds.height)))
    case .top, .bottom:
      position = CGFloat(arc4random_uniform(UInt32(screenBounds.width)))
    }
    
    // Add the new enemy to the view
    let dotView = UIView(frame: .zero)
    dotView.bounds.size = CGSize(width: radius, height: radius)
    dotView.backgroundColor = getRandomColor()
    
    switch screenEdge! {
    case .left:
      dotView.center = CGPoint(x: 0, y: position)
    case .right:
      dotView.center = CGPoint(x: screenBounds.width, y: position)
    case .top:
      dotView.center = CGPoint(x: position, y: screenBounds.height)
    case .bottom:
      dotView.center = CGPoint(x: position, y: 0)
    }
    
    view.addSubview(dotView)
    
    // Start animation
    let duration = getDotDuration(dotView: dotView)
    let dotAnimator = UIViewPropertyAnimator(duration: duration,
                                               curve: .linear,
                                               animations: { [weak self] in
                                                if let strongSelf = self {
                                                  dotView.center = strongSelf.collectorView.center
                                                }
      }
    )
    dotAnimator.startAnimation()
    dotAnimators.append(dotAnimator)
    dotViews.append(dotView)
  }
  
  @objc func tick(sender: CADisplayLink) {
    updateCountUpTimer(timestamp: sender.timestamp)
    checkCollision()
  }
}

fileprivate extension ZeroWorldViewController {
  func setupCollectorView() {
    collectorView.bounds.size = CGSize(width: radius * 2, height: radius * 2)
    collectorView.layer.cornerRadius = radius
    collectorView.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.4549019608, blue: 0.9607843137, alpha: 1)
    
    view.addSubview(collectorView)
  }
  
  func startDotTimer() {
    dotTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(generateDot(timer:)), userInfo: nil, repeats: true)
  }
  
  func stopDotTimer() {
    guard let dotTimer = dotTimer,
      dotTimer.isValid else {
        return
    }
    dotTimer.invalidate()
  }
  
  func startDisplayLink() {
    displayLink = CADisplayLink(target: self, selector: #selector(tick(sender:)))
    displayLink?.add(to: RunLoop.main, forMode: .default)
  }
  
  func stopDisplayLink() {
    displayLink?.isPaused = true
    displayLink?.remove(from: RunLoop.main, forMode: .default)
    displayLink = nil
  }
  
  func getRandomColor() -> UIColor {
    let index = arc4random_uniform(UInt32(colors.count))
    return colors[Int(index)]
  }
  
  func getDotDuration(dotView: UIView) -> TimeInterval {
    let dx = collectorView.center.x - dotView.center.x
    let dy = collectorView.center.y - dotView.center.y
    return TimeInterval(sqrt(dx * dx + dy * dy) / dotSpeed)
  }
  
  func collectOver() {
    stopCollect()
    displayCollectOverAlert()
  }
  
  func stopCollect() {
    stopDotTimer()
    stopDisplayLink()
    stopAnimators()
    zeroWorldState = .collectOver
  }
  
  func prepareCollect() {
    getBestTime()
    removeEnemies()
    centerCollectorView()
    popCollectorView()
    startLabel.isHidden = false
    clockLabel.text = "00:00.000"
    zeroWorldState = .ready
  }
  
  func startCollect() {
    startDotTimer()
    startDisplayLink()
    startLabel.isHidden = true
    beginTimestamp = 0
    zeroWorldState = .playing
  }
  
  func removeEnemies() {
    dotViews.forEach {
      $0.removeFromSuperview()
    }
    dotViews = []
  }
  
  func stopAnimators() {
    collectorAnimator?.stopAnimation(true)
    collectorAnimator = nil
    dotAnimators.forEach {
      $0.stopAnimation(true)
    }
    dotAnimators = []
  }
  
  func updateCountUpTimer(timestamp: TimeInterval) {
    if beginTimestamp == 0 {
      beginTimestamp = timestamp
    }
    elapsedTime = timestamp - beginTimestamp
    clockLabel.text = format(timeInterval: elapsedTime)
  }
  
  func format(timeInterval: TimeInterval) -> String {
    let interval = Int(timeInterval)
    let seconds = interval % 60
    let minutes = (interval / 60) % 60
    let milliseconds = Int(timeInterval * 1000) % 1000
    return String(format: "%02d:%02d.%03d", minutes, seconds, milliseconds)
  }
  
  /*
   presentation： 获取当前显示的layer的copy
   intersects: 判断两个rect是否有交集，有交集就认为游戏失败collectOver
   */
  func checkCollision() {
    dotViews.forEach {
      guard let collectorFrame = collectorView.layer.presentation()?.frame,
        let dotFrame = $0.layer.presentation()?.frame,
        collectorFrame.intersects(dotFrame) else {
          return
      }
      collectOver()
    }
  }
  
  func moveCollector(to touchLocation: CGPoint) {
    collectorAnimator = UIViewPropertyAnimator(duration: collectorAnimationDuration,
                                            dampingRatio: 0.5,
                                            animations: { [weak self] in
                                              self?.collectorView.center = touchLocation
    })
    collectorAnimator?.startAnimation()
  }
  
  func moveDots(to touchLocation: CGPoint) {
    // enumerated 得到索引和值
    for (index, enemyView) in dotViews.enumerated() {
      let duration = getDotDuration(dotView: enemyView)
      dotAnimators[index] = UIViewPropertyAnimator(duration: duration,
                                                     curve: .linear,
                                                     animations: {
                                                      enemyView.center = touchLocation
      })
      dotAnimators[index].startAnimation()
    }
  }
  
  func displayCollectOverAlert() {
    let (title, message) = getCollectOverTitleAndMessage()
    let alert = UIAlertController(title: "Collect Over", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: title, style: .default,
                               handler: { _ in
                                self.prepareCollect()
    }
    )
    alert.addAction(action)
    if let presented = self.presentedViewController {
      presented.removeFromParent()
    }
    
    if presentedViewController == nil {
      self.present(alert, animated: true, completion: nil)
    }

  }
  
  func getCollectOverTitleAndMessage() -> (String, String) {
    let elapsedSeconds = Int(elapsedTime) % 60
    setBestTime(with: format(timeInterval: elapsedTime))
    
    switch elapsedSeconds {
    case 0..<10: return ("I try again 😂", "Seriously, you need more practice 😒")
    case 10..<30: return ("Another go 😉", "No bad, you are getting there 😁")
    case 30..<60: return ("Play again 😉", "Very good 👍")
    default:
      return ("Off cause 😚", "Legend, olympic collector, go 🇧🇷")
    }
  }
  
  func centerCollectorView() {
    // Place the collector in the center of the screen.
    collectorView.center = view.center
  }
  
  // Copy from IBAnimatable
  func popCollectorView() {
    let animation = CAKeyframeAnimation(keyPath: "transform.scale")
    animation.values = [0, 0.2, -0.2, 0.2, 0]
    animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    animation.duration = CFTimeInterval(0.7)
    animation.isAdditive = true
    animation.repeatCount = 1
    animation.beginTime = CACurrentMediaTime()
    collectorView.layer.add(animation, forKey: "pop")
  }
  
  func setBestTime(with time:String){
    let defaults = UserDefaults.standard
    defaults.set(time, forKey: "bestTime")
    
  }
  
  func getBestTime(){
    let defaults = UserDefaults.standard
    
    if let time = defaults.value(forKey: "bestTime") as? String {
      self.bestTimeLabel.text = "Best Time: \(time)"
    }
  }
  
}

