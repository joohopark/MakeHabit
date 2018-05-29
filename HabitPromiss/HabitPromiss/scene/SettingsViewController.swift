//
//  SettingsViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 24..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
  
  @IBOutlet var tap: UITapGestureRecognizer!
  @IBOutlet weak var userTextField: UITextField!
  @IBOutlet weak var alarmSwitch: UISwitch!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
  }
}
