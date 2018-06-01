//
//  PromissListCell.swift
//  HabitPromiss
//
//  Created by 배지호 on 2018. 5. 28..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit
import FSCalendar
class PromissListCell: UITableViewCell {
  
  @IBOutlet weak var tableCellCalendar: FSCalendar!
  @IBOutlet weak var promissListText: UILabel!
  
  //calendar dateFormatter 로직
  let gregorian = Calendar(identifier: .gregorian)
  let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    tableCellCalendar.delegate = self
    tableCellCalendar.dataSource = self
    tableCellCalendar.scrollDirection = .horizontal//calendar scroll
    tableCellCalendar.swipeToChooseGesture.isEnabled = true
    tableCellCalendar.allowsMultipleSelection = true
    tableCellCalendar.clipsToBounds = true
    tableCellCalendar.tintColor = UIColor.green
    
    self.tableCellCalendar.accessibilityIdentifier = "FSCalendar"
  }
}
