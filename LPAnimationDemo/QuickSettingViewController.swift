//
//  QuickSettingViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/21.
//  Copyright © 2018 fcs. All rights reserved.
//

import QuickTableViewController

class QuickSettingViewController: QuickTableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableContents = [
      Section(title: "Switch", rows: [
        SwitchRow(title: "Setting 1", switchValue: true, action: { _ in }),
        SwitchRow(title: "Setting 2", switchValue: false, action: { _ in }),
        ]),
      
      Section(title: "Tap Action", rows: [
        TapActionRow(title: "Tap action", action: { [weak self] in self?.showAlert($0) })
        ]),
      
      Section(title: "Navigation", rows: [
        NavigationRow(title: "CellStyle.default", subtitle: .none, icon: .named("gear")),
        NavigationRow(title: "CellStyle", subtitle: .belowTitle(".subtitle"), icon: .named("globe")),
        NavigationRow(title: "CellStyle", subtitle: .rightAligned(".value1"), icon: .named("time"), action: { _ in }),
        NavigationRow(title: "CellStyle", subtitle: .leftAligned(".value2"))
        ]),
      
      RadioSection(title: "Radio Buttons", options: [
        OptionRow(title: "Option 1", isSelected: true, action: didToggleOption()),
        OptionRow(title: "Option 2", isSelected: false, action: didToggleOption()),
        OptionRow(title: "Option 3", isSelected: false, action: didToggleOption())
        ], footer: "See RadioSection for more details.")
    ]
  }
  
  // MARK: - Actions
  
  private func showAlert(_ sender: Row) {
    // ...
  }
  
  private func didToggleOption() -> (Row) -> Void {
    return { [weak self] row in
      // ...
    }
  }
  
}
