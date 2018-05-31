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
    
    // HabitManager 램 개체 컬렉션
    var habitList: Results<HabitManager>?
    // reload에 사용될 노티 토큰
    var reactivecHabitListToken: NotificationToken?
    
  
  var refresControl: UIRefreshControl = {
    let refresControl = UIRefreshControl()
    refresControl.addTarget(self, action: #selector(giveDetailView(_:)), for: .valueChanged)
    refresControl.tintColor = .red
    return refresControl
  }()
  
  @objc func giveDetailView(_ refresControl: UIRefreshControl) {
    
    let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "PromissDetailViewController") as! PromissDetailViewController
    self.present(nextViewController, animated: true, completion: nil)
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 10.0, *){
      promissTableView.refreshControl = refresControl
    } else{
      self.promissTableView.addSubview(self.refresControl)
    }
    
    // 뷰가 처음 띄워 질때 Habit Realm Object를 불러온다.
    habitList = HabitManager.getRealmObjectList(filterStr: "sucessPromiss == false", sortedBy: HabitManager.Property.sucessPromiss)
    
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 뷰가 다시 띄워질때 테이블 뷰를 리로드 한다.
        // 리프레시 컨트롤을 끝낸다.
        // 불러와진 램 개체를 불러와 출력. 에러일때는 에러 출력.
        reactivecHabitListToken = habitList?.observe({ [weak self](changeResult) in
            guard let `self` = self else { return }
            switch changeResult{
            case .initial:
                self.promissTableView.reloadData()
                self.refresControl.endRefreshing()
                print(self.habitList ?? "realm Habit object Load failed")
            case .update(_,let deletions, let insertions, let modifications):
                break
            case .error(let err):
                print("reactive Habit List Token occur err : \(err)")
            }
        })
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
      self.chartDetailView.frame = self.view.bounds
      self.chartDetailView.alpha = 1
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
      self.chartDetailView.alpha = 0
      self.pieChart.transform = CGAffineTransform(translationX: 0.2, y: 0.2)
      
      UIView.animate(withDuration: 0.5) {
        self.chartDetailView.alpha = 1
        self.pieChart.transform = CGAffineTransform.identity
      }
    }
  }
  @IBAction func backBtn(_ sender: UIButton) {
    UIView.animate(withDuration: 0.4, animations: {
      self.chartDetailView.alpha = 0
    }) { (status) in
      self.chartDetailView.removeFromSuperview()
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return (habitList?.count)!
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: promissCellIdentifier, for: indexPath) as! PromissListCell
    cell.promissListText.text = habitList?[indexPath.row].habitName
    return cell
  }
}
