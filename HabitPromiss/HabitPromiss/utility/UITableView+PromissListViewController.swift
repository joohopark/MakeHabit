//
//  UITableView+PromissListViewController.swift
//  HabitPromiss
//
//  Created by 배지호 on 2018. 6. 1..
//  Copyright © 2018년 주호박. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import Charts
import RealmSwift
import UserNotifications

//MARK: - Extension
//UITableViewDelegate
extension PromissListViewController: UITableViewDelegate {
  //tableviewCell 높이 설정
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.layer.transform = CATransform3DMakeScale(0, 0, 0)
    UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
      cell.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
    }, completion: nil)
  }
}

//UITableViewDataSoure
extension PromissListViewController: UITableViewDataSource {
  //cell이 선택된 이후
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    
    //tableView Cell을 선택했을 때 선택 스타일
    let selectCell = tableView.cellForRow(at: indexPath)!
    selectCell.selectionStyle = .none
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    //pieChart Data 만들기
    
    ChartManager.makePieChart(selectItem: habitList![indexPath.row]) { (result) in
      switch result {
      case .sucess(let value):
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CelldetailViewController") as! CelldetailViewController
        vc.chart = value as! PieChartData
        vc.selectHabit = self.habitList![indexPath.row]
        vc.firstDate = self.habitList?[indexPath.row].startDate
        vc.lastDate = self.habitList?[indexPath.row].endDate
        
        for goalDate in (self.habitList?[indexPath.row].goalDate)!{
          vc.goalDateList.append(formatter.date(from: goalDate)!)
        }
        
        for promissDate in (self.habitList?[indexPath.row].promissDate)!{
          vc.passDayList.append(formatter.date(from: promissDate)!)
        }
        print("넘어갑니다~ 차트만들면서~ \(self.habitList![indexPath.row].goalDate) 목표일 / \(self.habitList![indexPath.row].promissDate) 달성일")
        vc.nowTableIndex = indexPath.row
        self.present(vc, animated: true, completion: nil)
      case .error(let error):
        print(error.localizedDescription)

      }
    }
    
  }
  
  
  //tableView section당 로우갯수 표시
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    habitList =  HabitManager.getRealmObjectListWithoutSorted(filterStr: "sucessPromiss == false")
    if habitList?.count == 0 {
      return 1
    }
    return (habitList?.count)!
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "promissCell", for: indexPath) as! PromissListCell
    
    // 테이블에 습관을 모두 성공으로 이관했을때 예외처리.
    if habitList?.count == 0 {
      cell.promissListText.text = "현재 등록된 습관이 없습니다."
      cell.imgView.image = #imageLiteral(resourceName: "check")
      cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
      cell.isSelected = false
    }else{
      cell.promissListText.text = habitList?[indexPath.row].habitName
      switch habitList?[indexPath.row].iConNo.components(separatedBy: "_")[0] {
      case "0":
        cell.imgView.image = UIImage(named: "health_\(habitList?[indexPath.row].iConNo.components(separatedBy: "_")[1] ?? "0")")
      case "1":
        cell.imgView.image = UIImage(named: "study_\(habitList?[indexPath.row].iConNo.components(separatedBy: "_")[1] ?? "0")")
      case "2":
        cell.imgView.image = UIImage(named: "etc_\(habitList?[indexPath.row].iConNo.components(separatedBy: "_")[1] ?? "0")")
      default:
        print("cannot present img ...")
      }
      cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
      cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2
    }
    return cell
  }
  
  //PromissListViewController에서 만든 리스트를 스와이프할 수 있는 코드
// 악세사리들을 추가하고 해당 엑션을 정의
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let realm = try! Realm()
    //habitList count가 0일때 스와이프 예외처리
    if habitList?.count == 0 {
      let config = UISwipeActionsConfiguration()
      config.performsFirstActionWithFullSwipe = false
      return config
    } else {
      //삭제
      let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, nil) in
        realm.beginWrite()
        let habitIndex = self.habitList?[indexPath.row]
        realm.delete(habitIndex!)
        self.promissTableView.reloadData()
        try! realm.commitWrite()
      }
      //공유
      let shareAction = UIContextualAction(style: .normal, title: "공유") { (action, view, nil) in
        realm.beginWrite()
        let habitIndex = self.habitList?[indexPath.row]
        habitIndex?.sucessPromiss = true
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(habitIndex?.habitName)!])
        print("\(habitIndex?.habitName ?? "현재 선택된 습관이 없어요")에 대한 알람 해제")
        self.promissTableView.reloadData()
        try! realm.commitWrite()
        print("공유")
      }
      shareAction.backgroundColor = UIColor.orange
      //풀 스와이프를 없애는 코드
      let config = UISwipeActionsConfiguration(actions:[deleteAction,shareAction])
      config.performsFirstActionWithFullSwipe = false
      return config
    }
  }
  
}
