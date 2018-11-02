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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    leftTableView.delegate = self
    leftTableView.dataSource = self
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
  
  
}


