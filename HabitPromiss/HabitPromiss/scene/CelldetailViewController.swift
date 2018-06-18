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
}

//MARK:- ViewLifeCycle
extension CelldetailViewController{
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("celldetailViewController viewWillDisappear")
    reactiveHabitChartToken?.invalidate()
  }
  
  override func viewDidLoad() {
    print("celldetailViewController ViewDidLoad")
    super.viewDidLoad()
    print("현재 뷰가 불리면서 \(selectHabit) 을 물고있어요")
    print("현재 차트보기 뷰가 물고있는 indexPath ========== \(nowTableIndex ?? 0)")
    drowCalendar()
    drowPieChart()
    dismissView()
  }
    
}

//MARK:- IBAction Extension
extension CelldetailViewController{
    // dismiss 되기전에 REalm에 현재 상황을 저장.
    @IBAction func dismissButton(_ sender: UIButton) {
        do{
            try Realm().safeWrite {
                try Realm().add(self.selectHabit)
            }
        }catch{
            print(error.localizedDescription)
        }
        self.dismiss(animated: true, completion: nil)
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
        
        // 날짜 선택 했든 안했던 현재 상태를 REalm에 쓰고 넘어가도록 
        do{
            try Realm().safeWrite {
                    try Realm().add(self.selectHabit)
            }
        }catch{
            print(error.localizedDescription)
        }
        print("dimiss detail View")
        print("dismiss 될때 \(selectHabit)")
      self.dismiss(animated: true, completion: nil)
    }
  }
}


