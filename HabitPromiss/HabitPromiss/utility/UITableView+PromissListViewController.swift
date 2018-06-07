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
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

//UITableViewDataSoure
extension PromissListViewController: UITableViewDataSource {
  //cell이 선택된 이후
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.tag == 0 {
      //tableView Cell을 선택했을 때 선택 스타일
      let selectCell = tableView.cellForRow(at: indexPath)!
      selectCell.selectionStyle = .none
      //pieChart Data 만들기
      ChartManager.makePieChart(indexPath: indexPath.row) { (result) in
        switch result {
        case .sucess(let value):
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "CelldetailViewController") as! CelldetailViewController
          vc.chart = value as! PieChartData
          self.present(vc, animated: true, completion: nil)
        case .error(let error):
          print(error.localizedDescription)
        }
      }
    }
    
    let detailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CelldetailViewController") as! CelldetailViewController
    detailView.selectHabit = self.habitList![indexPath.row]
    detailView.firstDate = self.habitList?[indexPath.row].startDate
    detailView.lastDate = self.habitList?[indexPath.row].endDate
    detailView.nowTableIndex = indexPath.row
    self.present(detailView, animated: true, completion: nil)
  }

  //tableView section 표시
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (habitList?.count)!
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "promissCell", for: indexPath) as! PromissListCell
    cell.promissListText.text = habitList?[indexPath.row].habitName
    return cell
  }
}
