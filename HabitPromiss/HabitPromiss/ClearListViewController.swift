//
//  ClearListViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 24..
//  Copyright © 2018년 주호박. All rights reserved.

import UIKit

class ClearListViewController: BaseViewController {
  
  @IBOutlet weak var clearListTableView: UITableView!
  private var clearListCellIdentifier: String = "clearListCell"
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}

extension ClearListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
}
extension ClearListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: clearListCellIdentifier, for: indexPath) as! ClearListCell
    
    return cell
  }
}
