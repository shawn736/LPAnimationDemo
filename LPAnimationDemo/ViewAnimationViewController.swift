//
//  ViewAnimationViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/2.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit

class ViewAnimationViewController: BaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    leftTableView.delegate = self
    leftTableView.dataSource = self
  }
  
}

extension ViewAnimationViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
    return cell
  }
  
  
}


