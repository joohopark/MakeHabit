//
//  PromissListViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 24..
//  Copyright © 2018년 주호박. All rights reserved.

import UIKit
import Charts
import RealmSwift
import FSCalendar

class PromissListViewController: BaseViewController {
  
  // IBOutlet Hook up
  @IBOutlet weak var promissTableView: UITableView!
  
  // HabitManager 램 개체 컬렉션
  var habitList: Results<HabitManager>?
  // reload에 사용될 노티 토큰
  var reactivecHabitListToken: NotificationToken?
  
  //MARK: - View UI 로직
  //refresControl View UI 로직
  var refresControl: UIRefreshControl = {
    let refresControl = UIRefreshControl()
    let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
    let attributesTitle = NSAttributedString(string: "아래로 당겨주세요", attributes: attributes)
    refresControl.addTarget(self, action: #selector(giveDetailView(_:)), for: .valueChanged)
    refresControl.tintColor = .red
    refresControl.backgroundColor = UIColor.clear
    refresControl.attributedTitle = attributesTitle
    return refresControl
  }()
  
  //화면을 끝까지 아래로 당겼을 때 실행
  @objc func giveDetailView(_ refresControl: UIRefreshControl) {
    let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "PromissDetailViewController") as! PromissDetailViewController
    self.present(nextViewController, animated: true, completion: nil)
  }
  
  //MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //버전별 refresControl addSubView
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
