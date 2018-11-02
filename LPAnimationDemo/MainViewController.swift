//
//  ViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/2.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  let configData = ["View Animations", "Auto Layout", "Layer Animations", "View Controller Transitions", "3D Animations", "Animations With UIViewPropertyAnimator", "Further types of animations"]

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "iOS Animations"
    
  }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return configData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
    let label = cell.viewWithTag(10) as! UILabel
    label.text = configData[indexPath.item]
    return cell
  }
  
  
}

