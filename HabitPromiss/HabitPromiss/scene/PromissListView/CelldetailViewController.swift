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
      calendarView.scrollDirection = .horizontal//calendar scroll
      calendarView.swipeToChooseGesture.isEnabled = true
      calendarView.allowsMultipleSelection = true
      calendarView.clipsToBounds = true
      calendarView.tintColor = UIColor.green
      calendarView.accessibilityIdentifier = "FSCalendar"
      calendarView.reloadData()
    }
}

extension CelldetailViewController {
  
}
