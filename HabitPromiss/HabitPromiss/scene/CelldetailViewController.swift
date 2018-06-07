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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    drowCalendar()
    drowPieChart()
    dismissView()
    reactiveHabitChartToken = try! Realm().objects(HabitManager.self).observe({ (change) in
        switch change {
        case .initial:
                self.drowPieChart()
        case .update(_,let deletions, let insertions, let modifications):
            self.drowPieChart()
            self.pieChart.data?.notifyDataChanged()
            print("차트 업뎃 탓어")
            ChartManager.makePieChart(indexPath: self.nowTableIndex!, completion: { (result) in
                switch result{
                case .sucess(let val):
                    self.chart = val as! PieChartData
                case .error(let err):
                    print(err)
                }
            })
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
//    pieChart.backgroundColor = UIColor(named: "iosColor")
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


