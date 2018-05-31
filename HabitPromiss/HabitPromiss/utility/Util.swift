//
//  Alert+CalculDate.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 30..
//  Copyright © 2018년 주호박. All rights reserved.
//

import Foundation
import UIKit

enum SomethingResult<T>{
    
}

class Util {
    // 제목, 내용을 받아 alert를 띄우는데 호출 시점에 Alert 오키 누른 시점에서 수행될 코드를 넣을수 있는 함수
    static func toNotifyUserAlert(title: String, message: String? = nil,
                           parentController: UIViewController) {
        
        let alertController: UIAlertController = UIAlertController(title: title,
                                                                   message: message,
                                                                   preferredStyle: .alert)
        
        let alertAction: UIAlertAction = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(alertAction)
        
        // present
        // 알랏 컨트롤러는 항상 부모 컨트롤러 가 존재 해야한다. 
        //    let root = UIApplication.shared.keyWindow?.rootViewController
        parentController.present(alertController, animated: true, completion: nil)
    }
    
    // 문자열로 되어있는 연월일에 대한 리스트를 받아서 총 일수를 반환해줌.
    static func calculateTotalDate(dateList: [String]) -> Int{
        if dateList.count != 3 { return 0 }
        
        // leaf yaer 고려 안했음...!
        let yearDayByMonthList: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        var resVal = 0
        print(dateList)
        // 입력 월-1 인덱스 만큼 결과 일에 누적
        for index in 0..<Int(dateList[1])!-1{
            resVal += yearDayByMonthList[index]
        }
        // 입력값으로 세퍼레이트 할때 ". " 로 해서 여기서 마지막인덱스는 변경해줌.
        return resVal+Int(dateList[2].components(separatedBy: ".")[0])! // 월 누적일 + 일
    }

    static func convertTo24Hour(beforeConvertTime: String) -> String{
        var separatedTimeStrList = beforeConvertTime.components(separatedBy: " ")
        if separatedTimeStrList[0] != "오전"{
            separatedTimeStrList[1] = String(Int(separatedTimeStrList[1].components(separatedBy: ":")[0])! + 12)
                + ":\(separatedTimeStrList[1].components(separatedBy: ":")[1])"
        }
        return separatedTimeStrList[1]
    }
}






