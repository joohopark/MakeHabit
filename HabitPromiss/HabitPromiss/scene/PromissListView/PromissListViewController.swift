//
//  PromissListViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 24..
//  Copyright © 2018년 주호박. All rights reserved.

import UIKit
import Charts
import RealmSwift

class PromissListViewController: BaseViewController {
  
  @IBOutlet var chartDetailView: UIView!
  @IBOutlet weak var pieChart: PieChartView!
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
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.tag == 0 {
      self.chartDetailView.frame = CGRect(x: 0, y: 100, width: 375, height: 500)
      self.chartDetailView.alpha = 0.6
      chartDetailView.backgroundColor = UIColor.darkGray
      self.promissTableView.addSubview(chartDetailView)
      ChartManager.makePieChart(indexPath: indexPath.row) { (result) in
        switch result {
        case .sucess(let value):
          self.pieChart.data = value
          self.chartDetailView.addSubview(self.pieChart)
        case .error(let error):
          print(error.localizedDescription)
        }
      }
      
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return array.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: promissCellIdentifier, for: indexPath) as! PromissListCell
    cell.promissListText.text = array[indexPath.row]
    return cell
  }
}
