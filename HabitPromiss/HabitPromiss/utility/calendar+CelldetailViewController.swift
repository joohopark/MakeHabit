//
//  calendar+PromissListViewController.swift
//  HabitPromiss
//
//  Created by 배지호 on 2018. 6. 1..
//  Copyright © 2018년 주호박. All rights reserved.
//

import Foundation
import FSCalendar
import RealmSwift
import Charts

extension CelldetailViewController: FSCalendarDelegate {
    
    // 선택시와 선택해제시 날짜 배열들에 대한 처리
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        switch formatter.string(from: date) {
        case formatter.string(from: calendar.today!):
            
            for index in 0..<goalDateList.count{
                print(goalDateList.count)
                if date == goalDateList[index] && index < goalDateList.count{
                    goalDateList.remove(at: index)
                    break
                }
            }
            
            if passDayList.contains(date){
                print("약속일 추가 이미 됨.....")
            }else{
                passDayList.append(date)
            }
            // index, goalDateList, passDayList
            HabitManager.shouldPerFormAppendDatePromissList(promis: selectHabit, passDateList: self.passDayList, goalDateList: self.goalDateList)
            // 메모리의 리스트를 렘에 썻음..
            
            print("promiss suc : \(passDayList),,,,,, \(goalDateList)")
            print("check selectHabit\(selectHabit.promissDate).,,,,,,,,\(selectHabit.goalDate)")
            print("날짜 선택했어:\(selectHabit.promissDate.count),,,,, count \(selectHabit.currentCount)")
            
            //습관에 대한 값이 변해서 차트를 다시그립니다.
            ChartManager.makePieChart(selectItem: selectHabit, completion: { (result) in
                switch result{
                case .sucess(let val):
                    self.chart = val as! PieChartData
                    
                case .error(let err):
                    print(err)
                }
            })
            self.drowPieChart()
            return true// 오늘을 제외하면 선택되지 않는다.
        default:
            return false
        }
        
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        switch formatter.string(from: date) {
        case formatter.string(from: calendar.today!):
            for index in 0..<passDayList.count{
                if date == passDayList[index] {
                    passDayList.remove(at: index)
                    break
                    
                }
            }
            print("\(passDayList) 현재 약속 일수임..\(date)가 삭제 되었음?")
            
            if goalDateList.contains(date){
                print("목표일수 이미 추가되있음")
            }else{
                goalDateList.append(date)
            }
            HabitManager.shouldPerFormAppendDatePromissList(promis: selectHabit, passDateList: self.passDayList, goalDateList: self.goalDateList)
            //램에 선택된 데이터를 빼!
            HabitManager.add(addedHabit: selectHabit) { (result) in
                self.selectHabit.currentCount = self.selectHabit.promissDate.count
            }
            
            print("promiss cancel : \(passDayList),,,,,, \(goalDateList)")
            print("날짜선택 취소했어:\(selectHabit.currentCount)")
            ChartManager.makePieChart(selectItem: selectHabit, completion: { (result) in
                switch result{
                case .sucess(let val):
                    self.chart = val as! PieChartData
                    
                case .error(let err):
                    print(err)
                }
            })
            self.drowPieChart()
            return true// 오늘을 제외하면 선택되지 않는다.
        default:
            return false
        }
    }
    
    
}

extension CelldetailViewController: FSCalendarDataSource {
    // 목표일로 잡은 주기
    //calendar 날짜가 시작되는 시점
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.convertDate.date(from: firstDate!)!
    }
    //MARK: TodayMaximumDate
    //maximumDate 부분
    //calendar 마지막날짜 표시
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.convertDate.date(from: lastDate!)!
    }
}

extension CelldetailViewController: FSCalendarDelegateAppearance{
    // 날짜 표시에 대한 처리( 얘가 불리우는 순서가 있음.. 주의)
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let startDay = self.convertDate.date(from: firstDate!)!
        let endDay = self.convertDate.date(from: lastDate!)!
        
        switch date {
        case startDay...endDay:
            if goalDateList.contains(date){
                
            }else{
                goalDateList.append(date)
            }
        default:
            break
        }
        
        if goalDateList.contains(date){// 전체 날짜
            return UIColor.lightGray
        }else if passDayList.contains(date){// 약속지킨 날짜
            return UIColor.black
        }else{
            return nil
        }
    }
    
    
    
}




