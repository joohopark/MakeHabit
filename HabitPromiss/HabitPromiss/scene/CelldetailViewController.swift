//
//  CelldetailViewController.swift
//  HabitPromiss
//
//  Created by 배지호 on 2018. 6. 7..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
import FSCalendar

class CelldetailViewController: BaseViewController {
  
  var dismissDelegate: PromissListViewType?
  var passValue: Results<HabitManager>?
  
  @IBOutlet weak var pieChart: PieChartView!
  @IBOutlet weak var calendarView: FSCalendar!
  
  var firstDate: String?
  var lastDate: String?
  var nowTableIndex: Int?
  
  var goalDateList: [Date] = []
  var passDayList:[Date] = []
  
  // HabitManager 램 개체 컬렉션
  var selectHabit: HabitManager!
  var reactiveHabitChartToken: NotificationToken?
  
  var chart:PieChartData!
  
  //calendar dateFormatter 로직
  let gregorian = Calendar(identifier: .gregorian)
  let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
  
  let convertDate: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy. MM. dd."
    return f
  }()
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("celldetailViewController viewWillDisappear")
    reactiveHabitChartToken?.invalidate()
  }
  
  override func viewDidLoad() {
    print("celldetailViewController ViewDidLoad")
    super.viewDidLoad()
    print("현재 차트보기 뷰가 물고있는 indexPath ========== \(nowTableIndex)")
    drowCalendar()
    drowPieChart()
    dismissView()
    reactiveHabitChartToken = try! Realm().objects(HabitManager.self).observe({ (change) in
      switch change {
      case .initial:
        self.drowPieChart()
        
      case .update(_,let deletions, let insertions, let modifications):
        print("차트 업뎃 탓어", self.selectHabit.promissDate.count, self.selectHabit.totalCount)
        
        print(deletions,insertions,modifications,"업뎃 찍어보기")
        
        ChartManager.makePieChart(selectItem: self.selectHabit, completion: { (result) in
          switch result{
          case .sucess(let val):
            self.chart = val as! PieChartData
            
            
          case .error(let err):
            print(err)
          }
        })
        self.drowPieChart()
        print(self.selectHabit,"현재 선택된 습관 노티 토큰 안입니다")
        print("asdflkjsadlfjasdlfjsdalkfjsadlfjdsalkjf")
        // 이 if 안에서 realm에 업뎃 접근하면 크래쉬. 동일 트랜잭션에서 또 쓰면 안됨.
        //            if self.selectHabit.goalDate.count == 0{
        //                let realm = try! Realm()
        //                let item = self.selectHabit
        //
        //                do{
        //                    try realm.write {
        //                        item?.sucessPromiss = true
        //                        realm.add(item!)
        //                    }
        //                    Thread.sleep(forTimeInterval: 1)
        //                }catch{
        //                    print(error.localizedDescription)
        //                }
        //                self.dismiss(animated: true, completion: nil)
        //            }
        //            print("asdflkjsadlfjasdlfjsdalkfjsadlfjdsalkjf=================")
        
      case .error:
        break
      }
    })
    
  }
}

extension CelldetailViewController {
  //Calendar를 불러올때 설정해주는 부분
  func drowCalendar() {
    calendarView.scrollDirection = .vertical//calendar scroll
    calendarView.allowsMultipleSelection = true
    calendarView.clipsToBounds = true
  }
  //Chart를 불러올때 설정해주는 부분
  func drowPieChart() {
    pieChart.data = chart
    pieChart.entryLabelFont = UIFont(name: "NanumPen", size: 16)
    pieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)
    self.pieChart.data?.notifyDataChanged()
  }
  //CelldetailViewController Dismiss를 위한 제스처
  func dismissView() {
    let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
    edgePan.edges = .left
    
    
    view.addGestureRecognizer(edgePan)
  }
  //dissmiss Action 부분
  @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
    if recognizer.state == .recognized {
      self.dismiss(animated: true, completion: nil)
    }
  }
}


