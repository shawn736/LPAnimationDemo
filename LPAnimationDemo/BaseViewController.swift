//
//  BaseViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/2.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  
  var leftTableView: UITableView! // 左侧列表
  var storyView: UIView! // 右侧演示动画的页面
  var storyImageView: UIImageView! //演示用的图片
  let initialStoryImageViewFrame = CGRect(x: 50, y: 50, width: 80, height: 104)
  
  fileprivate var titleName: String = "Animations"
  let duration = 0.5 //动画时长
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initUIView()
    title = titleName
    let rightItem = UIBarButtonItem.init(title: "Start", style: .plain, target: self, action: #selector(startAnimation))
    self.navigationItem.rightBarButtonItem = rightItem
  }
  
  @objc func startAnimation() {}
  
  
  func setStoryImageView() {
    
    _ = storyView.subviews.map{ $0.removeFromSuperview() }

    storyImageView = UIImageView.init(frame: initialStoryImageViewFrame)
    storyImageView.image = UIImage.init(named: "balloon")
    storyView.addSubview(storyImageView)
  }
  
  func initUIView() {
    view.backgroundColor = .white
    let constraintHeight = self.navigationController?.navigationBar.frame.height ?? 0.0 + UIApplication.shared.statusBarFrame.height
    let leftWidth = 100
    
    leftTableView = UITableView.init()
    leftTableView.register(UINib.init(nibName: "mainCell", bundle: nil), forCellReuseIdentifier: "mainCell")
    view.addSubview(leftTableView)
    leftTableView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.top.equalTo(constraintHeight)
      make.bottom.equalToSuperview()
      make.width.equalTo(leftWidth)
    }
    
    storyView = UIView.init()
    view.addSubview(storyView)
    storyView.snp.makeConstraints { (make) in
      make.left.equalTo(leftWidth)
      make.top.equalTo(constraintHeight)
      make.bottom.equalToSuperview()
      make.right.equalToSuperview()
    }
    
    setStoryImageView()
    
  }
  
  convenience init(titleName: String) {
    self.init()
    self.titleName = titleName
  }

}

