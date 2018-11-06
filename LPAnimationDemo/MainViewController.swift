//
//  ViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/2.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet weak var mainTableView: UITableView!
  let configData = ["View Animations", "Layer Animations", "View Controller Transitions", "UIViewPropertyAnimator", "Further Types Of Animations"]

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "iOS Animations"
    mainTableView.register(UINib.init(nibName: "mainCell", bundle: nil), forCellReuseIdentifier: "mainCell")
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.item {
    case 0:
      let vc = ViewAnimationViewController(titleName: configData[indexPath.item])
      navigationController?.pushViewController(vc, animated: true)
    case 1:
      let vc = LayerAnimationViewController(titleName: configData[indexPath.item])
      navigationController?.pushViewController(vc, animated: true)
    case 2:
      let vc = ViewControllerTransitionsViewController(titleName: configData[indexPath.item])
      navigationController?.pushViewController(vc, animated: true)
    case 3:
      let vc = UIViewPropertyAnimatorViewController(titleName: configData[indexPath.item])
      navigationController?.pushViewController(vc, animated: true)
    case 4:
      let vc = FurtherTypesViewController(titleName: configData[indexPath.item])
      navigationController?.pushViewController(vc, animated: true)
    default:
      let vc = ViewAnimationViewController(titleName: configData[indexPath.item])
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}

