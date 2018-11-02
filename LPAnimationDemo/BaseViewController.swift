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
  var storyImageLayer: CALayer {
    return storyImageView.layer
  }
  let initialStoryImageViewFrame = CGRect(x: 20, y: 50, width: 80, height: 104)
  
  fileprivate var titleName: String = "Animations"
  let duration = 0.5 //动画时长
  var configData:[String] = []
  
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
    let leftWidth = 150
    
    leftTableView = UITableView.init()
    leftTableView.delegate = self
    leftTableView.dataSource = self
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

extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return configData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
    let label = cell.viewWithTag(10) as! UILabel
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = configData[indexPath.item]
    label.backgroundColor = .gray
    label.textColor = .white
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 45
  }
  
}

