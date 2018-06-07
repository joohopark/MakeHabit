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
        

        
      calendarView.scrollDirection = .horizontal//calendar scroll
      calendarView.swipeToChooseGesture.isEnabled = true
      calendarView.allowsMultipleSelection = true
      calendarView.clipsToBounds = true
      calendarView.tintColor = UIColor.green
      calendarView.accessibilityIdentifier = "FSCalendar"
      calendarView.reloadData()
      
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


