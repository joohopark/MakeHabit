//
//  PromissListViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 24..
//  Copyright © 2018년 주호박. All rights reserved.

import UIKit

class PromissListViewController: BaseViewController {
  
  @IBOutlet weak var promissTableView: UITableView!
  private var promissCellIdentifier: String = "promissCell"
  var array = ["1","2","1","2","1","2","1","2"]{
    didSet{
      self.refresControl.endRefreshing()
    }
  }
  
  
  var refresControl: UIRefreshControl = {
    let refresControl = UIRefreshControl()
    refresControl.addTarget(self, action: #selector(giveDetailView(_:)), for: .valueChanged)
    refresControl.tintColor = .red
    return refresControl
  }()
  
  @objc func giveDetailView(_ refresControl: UIRefreshControl) {
    
    let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "PromissDetailViewController") as! PromissDetailViewController
    self.present(nextViewController, animated: true, completion: nil)
    self.promissTableView.reloadData()
    let deadline = DispatchTime.now() + .milliseconds(500)
    DispatchQueue.main.asyncAfter(deadline: deadline) {
      self.array.append("3")
      self.refresControl.endRefreshing()
      self.promissTableView.reloadData()
    }
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 10.0, *){
      promissTableView.refreshControl = refresControl
    } else{
      self.promissTableView.addSubview(self.refresControl)
    }
  }
}

extension PromissListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

extension PromissListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return array.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: promissCellIdentifier, for: indexPath) as! PromissListCell
    cell.promissListText.text = array[indexPath.row]
    return cell
  }
}
