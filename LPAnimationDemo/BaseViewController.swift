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
  
  fileprivate var titleName: String = "Animations"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initUIView()
    title = titleName
  }
  
  func initUIView() {
    view.backgroundColor = .white
    let constraintHeight = self.navigationController?.navigationBar.frame.height ?? 0.0 + UIApplication.shared.statusBarFrame.height
    
    leftTableView = UITableView.init()
    leftTableView.backgroundColor = .green
    view.addSubview(leftTableView)
    leftTableView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.top.equalTo(constraintHeight)
      make.bottom.equalToSuperview()
      make.width.equalTo(100)
    }
    
    storyView = UIView.init()
    storyView.backgroundColor = .blue
    view.addSubview(storyView)
    storyView.snp.makeConstraints { (make) in
      make.left.equalTo(100)
      make.top.equalTo(constraintHeight)
      make.bottom.equalToSuperview()
      make.right.equalToSuperview()
    }
  }
  
  convenience init(titleName: String) {
    self.init()
    self.titleName = titleName
  }

}

