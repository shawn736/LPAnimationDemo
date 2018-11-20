//
//  DrawerViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/20.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit
import TableViewDragger

class DrawerViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var dragger: TableViewDragger!
  var configData: [UIColor] = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
    override func viewDidLoad() {
        super.viewDidLoad()
      dragger = TableViewDragger(tableView: tableView)
      dragger.availableHorizontalScroll = true
      dragger.dataSource = self
      dragger.delegate = self
      dragger.alphaForCell = 0.7
    }

}

extension DrawerViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return configData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell", for: indexPath)
    cell.backgroundColor = configData[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delelteRowAction = UIContextualAction(style: .destructive, title: "delete") { (action, sourceView, flag) in
      self.configData.remove(at: indexPath.row)
      tableView.reloadData()
    }
//    delelteRowAction.image = UIImage(named: "balloon")
    delelteRowAction.backgroundColor = UIColor.red
    let config = UISwipeActionsConfiguration(actions: [delelteRowAction])
    return config
  }
  
}

extension DrawerViewController: TableViewDraggerDataSource, TableViewDraggerDelegate {
  func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
    let color = configData[indexPath.row]
    configData.remove(at: indexPath.row)
    configData.insert(color, at: newIndexPath.row)
    tableView.moveRow(at: indexPath, to: newIndexPath)
    return true
  }  
}
