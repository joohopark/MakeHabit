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
    
//    print("\(habitList![indexPath.row])에 대한 차트가 그려질거에여========")
//    print(habitList,"습관 불러온거에요 이건 false에 대한거임")
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
        
        vc.nowTableIndex = indexPath.row
//        vc.dismissDelegate = self
//        print("테이블에서 물고들어가는 인덱스 패스 \(indexPath.row)")
//        print("\(self.habitList![indexPath.row].habitName) 물고 들어가는 습관이름")
        self.present(vc, animated: true, completion: nil)
      case .error(let error):
        print(error.localizedDescription)
      }
    }
    
  }

  
  //tableView section당 로우갯수 표시

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


    habitList =  HabitManager.getRealmObjectListWithoutSorted(filterStr: "sucessPromiss == false")

    if habitList?.count == 0{
        return 1
    }
        return (habitList?.count)!
    

  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "promissCell", for: indexPath) as! PromissListCell

    
    if habitList?.count == 0{
        cell.promissListText.text = "현재 등록된 습관이 없습니다."
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
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else {return}
    
    print("하빗리스트에서 지워야하는거 아님..?")
  }
  
}
