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

//MARK: - Extension
//UITableViewDelegate
extension PromissListViewController: UITableViewDelegate {
  //tableviewCell 높이 설정
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  // ...
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .delete {
      //이부분에 habitList의 indexPath.row를 지우면 끝
//      habitList
    }
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
    ChartManager.makePieChart(indexPath: indexPath.row) { (result) in
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
        
        vc.nowTableIndex = indexPath.row
        self.present(vc, animated: true, completion: nil)
      case .error(let error):
        print(error.localizedDescription)
      }
    }
    
  }
  
  //tableView section 표시
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (habitList?.count)!
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "promissCell", for: indexPath) as! PromissListCell
    cell.promissListText.text = habitList?[indexPath.row].habitName
    cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
    
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
    cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2
    return cell
  }
}
