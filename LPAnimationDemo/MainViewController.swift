//
//  ViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/2.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit
import MessageUI
import UIDeviceComplete

class MainViewController: UIViewController {
  
  @IBOutlet weak var mainTableView: UITableView!
  let configData = ["View Animations", "Layer Animations", "View Controller Transitions", "UIViewPropertyAnimator", "Further Types Of Animations", "Navigation Drawer", "Mail Respond", "Quick Setting", "Point Transform"]

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
    case 5:
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "DrawerViewController") as! DrawerViewController
      navigationController?.pushViewController(vc, animated: true)
    case 6:
      if MFMailComposeViewController.canSendMail() {
        //注意这个实例要写在if block里，否则无法发送邮件时会出现两次提示弹窗（一次是系统的）
        let mailComposeViewController = configuredMailComposeViewController()
        self.present(mailComposeViewController, animated: true, completion: nil)
      } else {
        self.showSendMailErrorAlert()
      }
    case 7:
      let vc = QuickSettingViewController()
      navigationController?.pushViewController(vc, animated: true)
    case 8:
      let vc = PointTransformViewController()
      vc.view.backgroundColor = .white
      navigationController?.pushViewController(vc, animated: true)
    default:
      let vc = ViewAnimationViewController(titleName: configData[indexPath.item])
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}

extension MainViewController: MFMailComposeViewControllerDelegate {
  func configuredMailComposeViewController() -> MFMailComposeViewController {
    
    let mailComposeVC = MFMailComposeViewController()
    mailComposeVC.mailComposeDelegate = self
    
    //设置邮件地址、主题及正文
    mailComposeVC.setToRecipients(["<你的邮箱地址>"])
    mailComposeVC.setSubject("<邮件主题>")
    
    mailComposeVC.setMessageBody("<邮件正文\n\n\n\n<\(UIDevice.current.dc.commonDeviceName)>", isHTML: false) //正文里 可以加上设备信息，系统版本， app版本信息。
    
    return mailComposeVC
    
  }
  
  func showSendMailErrorAlert() {
    
    let sendMailErrorAlert = UIAlertController(title: "无法发送邮件", message: "您的设备尚未设置邮箱，请在“邮件”应用中设置后再尝试发送。", preferredStyle: .alert)
    sendMailErrorAlert.addAction(UIAlertAction(title: "确定", style: .default) { _ in })
    self.present(sendMailErrorAlert, animated: true){}
    
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    switch result {
    case .cancelled:
      print("取消发送")
    case .sent:
      print("发送成功")
    default:
      break
    }
    self.dismiss(animated: true, completion: nil)
    
  }
}
