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
  
  var chart:PieChartData!
  
  var firstDate: String = "2018-06-10"
  var testsouce: String = "2018-06-20"
  var testList: [String] = ["2018-06-10","2018-06-11","2018-06-12","2018-06-13","2018-06-14"]
  
  //calendar dateFormatter 로직
  let gregorian = Calendar(identifier: .gregorian)
  let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    drowCalendar()
    drowPieChart()
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
    pieChart.backgroundColor = UIColor(named: "iosColor")
    pieChart.entryLabelFont = UIFont(name: "NanumPen", size: 16)
    pieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)
  }
}

