//
//  calendar+PromissListViewController.swift
//  HabitPromiss
//
//  Created by 배지호 on 2018. 6. 1..
//  Copyright © 2018년 주호박. All rights reserved.
//

import Foundation
import FSCalendar

extension PromissListCell: FSCalendarDelegate{
  //calendar가 실행되기 전
  func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
    print(date)
  }
}

extension PromissListCell: FSCalendarDataSource {
  func minimumDate(for calendar: FSCalendar) -> Date {
    return Date()
  }
  //MARK: TodayMaximumDate
  //maximumDate 부분
  //PromissDetailViewController에서 종료일을 입력하면 이곳으로 데이터가 입력...
  func maximumDate(for calendar: FSCalendar) -> Date {
    let threeMonthFromNow = self.gregorian.date(byAdding: .month, value: 2, to: Date(), wrappingComponents: true)
    return threeMonthFromNow!
  }
}
