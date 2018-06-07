//
//  SettingsViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 24..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UITableViewController {
    
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var alarmSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
	let user = UserInfo.getRealmObjectList(sortedBy: UserInfo.Property.nickName)
        if user != nil && user[0].nickName != ""{
            userTextField.text = user[0].nickName
        }
    }
    
    @IBAction func didChangeAlarmSwitch(_ sender: UISwitch) {
        
        // 이미 알람이 설정된 상태에서 넘어오기때문에 중복 설정되는것은 막아진다. ( 스위치.isOn 은 첨에 true니까..)
        if sender.isOn{
            // 렘에 알람 설정 값을 가져와서 다시 알람을 설정한다.
            UserInfo.didChangedAlarmValue(text: userTextField.text!,isOn: true) { (result) in
                switch result{
                case .sucess(let value):
                    print(value)
                case .error(let err):
                    print(err)
                }
            }
            // 모든 습관의 알람시간을 재설정하기위해 컬랙션 개체를 불러온다.
            // 그냥 컬렉션 개체를 사용하면 접근할때마다 Realm 개체를 만듦. -> 렘에서 그렇게 못하게 제한해서 엡이 죽음. 동 쓰레드에서 한번에 접근하는 개체수를 제한.
            // 그래서 map을 써서 아싸리 한번에 HabitManager 모델 컬렉션 개체로 만들어서 사용한다.
            let habitList = HabitManager.getRealmObjectList(filterStr: "sucessPromiss == false", sortedBy: HabitManager.Property.sucessPromiss).map { HabitManager.init($0.habitName,
                                                                                                                                                                        totalCount: $0.totalCount,
                                                                                                                                                                        currentCount: $0.currentCount, planedPiriod: $0.planedPiriod, sucessPromiss: $0.sucessPromiss, alarmTime: $0.alarmTime,
                                                                                                                                        iConNo: $0.iConNo)
            }
            

                // 개채의 인덱스 만큼 돌면서 습관을 설정한다. 이때 식별자는 습관명
                for habit in habitList{
                    let habitAlarmList = habit.alarmTime.components(separatedBy: ":")
                    var dateComponent = DateComponents()
                    dateComponent.hour = Int(habitAlarmList[0])
                    dateComponent.minute = Int(habitAlarmList[1])
                    
                    Util.timedNotification(date: dateComponent, identifierForAlarm: habit.habitName) { (result) in
                        switch result{
                        case true:
                            print(" \(habit.habitName)에 대한 알람 시간 \(habitAlarmList)의 재설정 완료.")
                        case false:
                            print("===UserNotification Add fail===")
                        }
                    }
                }
        }else{
            UserInfo.didChangedAlarmValue(text: userTextField.text!) { (result) in
                switch result{
                case .sucess(let value):
                    print(value)
                case .error(let err):
                    print(err)
                }
            }
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("알람 해제")
        }
    }
    
}
