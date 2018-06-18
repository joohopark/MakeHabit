//
//  calendar+PromissListViewController.swift
//  HabitPromiss
//
//  Created by 배지호 on 2018. 6. 1..
//  Copyright © 2018년 주호박. All rights reserved.
//

import Foundation
import FSCalendar


extension CelldetailViewController: FSCalendarDelegate {
  
  //calendar가 실행되기 전
//  func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//    let test = self.formatter.date(from: testsouce)!
//    let test2 = self.formatter.date(from: firstDate)!
//    for i in testList {
//      let list = self.formatter.date(from: i)!
//      if date == list {
//        cell.isSelected = true
//        cell.performSelecting()
//      }
//    }
//    cell.isSelected = false
//  }
}

extension CelldetailViewController: FSCalendarDataSource {
  //calendar 날짜가 시작되는 시점
//  func minimumDate(for calendar: FSCalendar) -> Date {
//    let test = self.formatter.date(from: firstDate)!
//
//    return test
//  }
////  //MARK: TodayMaximumDate
////  //maximumDate 부분
////  //calendar 마지막날짜 표시
//  func maximumDate(for calendar: FSCalendar) -> Date {
//    let test = self.formatter.date(from: testsouce)!
//    return test
//  }
}



