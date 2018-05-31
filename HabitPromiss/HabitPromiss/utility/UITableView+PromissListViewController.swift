//
//  UITableView+PromissListViewController.swift
//  HabitPromiss
//
//  Created by 배지호 on 2018. 6. 1..
//  Copyright © 2018년 주호박. All rights reserved.
//

import Foundation
import UIKit
//MARK: - Extension
//UITableViewDelegate
extension PromissListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 300
  }
}
//UITableViewDataSoure
extension PromissListViewController: UITableViewDataSource {
  //cell이 선택된 이후
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.tag == 0 {
      //promissTableView에 addSubview
      self.chartDetailView.alpha = 1
      chartDetailView.backgroundColor = UIColor.darkGray
      self.promissTableView.addSubview(chartDetailView)
      //pieChart Data 만들기
      ChartManager.makePieChart(indexPath: indexPath.row) { (result) in
        switch result {
        case .sucess(let value):
          self.pieChart.data = value
          self.chartDetailView.addSubview(self.pieChart)
        case .error(let error):
          print(error.localizedDescription)
        }
      }
      //chart Animation 부분
      self.chartDetailView.alpha = 0
      self.pieChart.transform = CGAffineTransform(translationX: 0.2, y: 0.2)
      UIView.animate(withDuration: 0.5) {
        self.chartDetailView.alpha = 1
        self.pieChart.transform = CGAffineTransform.identity
      }
    }
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (habitList?.count)!
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "promissCell", for: indexPath) as! PromissListCell
    cell.promissListText.text = habitList?[indexPath.row].habitName
    return cell
  }
}
