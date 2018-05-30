//
//  Alert+CalculDate.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 30..
//  Copyright © 2018년 주호박. All rights reserved.
//

import Foundation
import UIKit

func inputUserAlert(title: String, message: String? = nil,  callBack: @escaping (String) -> Void) {
    
    let alertController: UIAlertController = UIAlertController(title: title,
                                                               message: nil,
                                                               preferredStyle: .alert)
    alertController.addTextField { (textfield) in
        textfield.placeholder = "할일을 입력해주세요!"
    }
    
    let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (alert) in
        guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
        callBack(text)
    }
    
    alertController.addAction(alertAction)
    
    // present
    let root = UIApplication.shared.keyWindow?.rootViewController
    root?.present(alertController, animated: true, completion: nil)
    
}

// 문자열로 되어있는 연월일에 대한 리스트를 받아서 총 일수를 반환해줌.
func calculateTotalDate(dateList: [String]) -> Int{
    // leaf yaer 고려 안했음...!
    let yearDayByMonthList: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var resVal = 0
    print(dateList)
    // 입력 월-1 인덱스 만큼 결과 일에 누적
    for index in 0..<Int(dateList[1])!-1{
        resVal += yearDayByMonthList[index]
    }
    
    
    return resVal+Int(dateList[2].components(separatedBy: ".")[0])! // 월 누적일 + 일
}

