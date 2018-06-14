//
//  ClearListViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 24..
//  Copyright © 2018년 주호박. All rights reserved.

import UIKit
import RealmSwift
import Charts

class ClearListViewController: BaseViewController {
  
  @IBOutlet weak var clearListTableView: UITableView!
  private var clearListCellIdentifier: String = "clearListCell"
  var clearLsit: Results<HabitManager>?
  var userInfo: Results<UserInfo>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // REalm의 HabitManager Object를 통해서 successPromiss 필드의 값이 true인 아이들만 컬렉션으로 불러옴. ( viewDidload)
    clearLsit = HabitManager.getRealmObjectList(filterStr: "sucessPromiss == true", sortedBy: HabitManager.Property.sucessPromiss)
    userInfo = UserInfo.getRealmObjectList(sortedBy: UserInfo.Property.nickName)
    clearListTableView.reloadData()
    print(clearLsit)
  }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearListTableView.reloadData()
    }
}

extension ClearListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    ChartManager.makePieChart(selectItem: clearLsit![indexPath.row]) {(result) in
      switch result{
      case .sucess(let value):
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinishViewController") as? FinishViewController
        vc?.userData = self.userInfo?[0]
        vc?.clearData = self.clearLsit?[indexPath.row]
        vc?.chart = value as! PieChartData
        
        print(self.userInfo?[0], self.clearLsit?[indexPath.row])
        
        self.present(vc!, animated: true, completion: nil)
      case .error(let err):
        print("makeChart occur \(err)!!!")
      }
    }
    
  }
}
extension ClearListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return clearLsit?.count ?? 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: clearListCellIdentifier, for: indexPath) as! ClearListCell
    cell.clearText.text = clearLsit?[indexPath.row].habitName
    return cell
  }
  
}
