//
//  HabitManager.swift
//  RealmPrac
//
//  Created by 주호박 on 2018. 5. 25..
//  Copyright © 2018년 주호박. All rights reserved.
//

import Foundation
import RealmSwift

// Completion Handler에서 사용하기 위한 enum.
enum RealmResult<T>{
    case sucess(T)
    case error(Realm.Error)
}

protocol HabitManagerServiceType {
    associatedtype T: Object
    // 처음에 개체에 값 추가 하는 메소드.
    static func add(addedHabit: T , in realm: Realm, completion: @escaping (RealmResult<T>) -> ())
    // 알림 울렸을때 currentCount에 값이 추가되는 메소드
    // 알람 메소드
    // static func setAlarmInMyPhone()
}

class HabitManager: Object, HabitManagerServiceType{
    typealias T = HabitManager
    
    enum Property: String{
        case id, habitName, totalCount, currentCount, planedPiriod, sucessPromiss, alarmTime
    }
    
    //MARK:- Habit Table Attribute
    
    @objc dynamic var id: String = UUID().uuidString// 노 수정
    
    // 습관명
    // 사용자가 텍스트 필드에서 입력
    @objc dynamic var habitName: String = ""
    
    // 사용자가 정한 총 카운트
    // 사용자가 정한 기간(planedPiriod) 을 통해 정해짐.
    @objc dynamic var totalCount: Int = 0
    
    // 현재 수행 카운트
    // 알림 수행 횟수를 통해 카운트됨,
    @objc dynamic var currentCount: Int = 0
    
    // 사용자가 정한 기간 ( Date가 되야 할듯..)
    //사용자가 date picker를 통해 입력
    @objc dynamic var planedPiriod: String = ""
    
    // 약속 -> 성공 뷰로 넘어갈지에 대한 여부
    // totalCount == currentCount 가 될경우 true
    @objc dynamic var sucessPromiss: Bool = false
    
    // 사용자 지정 알람 시간
    // picker를 통해 입력된 사용자 알림 시간임
    @objc dynamic var alarmTime: String = ""
    
    
    convenience init(_ habitName: String, totalCount: Int, currentCount: Int,
                     planedPiriod: String = "", sucessPromiss: Bool = false, alarmTime: String = "") {
        self.init()
        self.habitName = habitName
        self.totalCount = totalCount
        self.currentCount = currentCount
        self.planedPiriod = planedPiriod
        self.sucessPromiss = sucessPromiss
        self.alarmTime = alarmTime
    }
    
    override static func primaryKey() -> String? {
        return Property.id.rawValue
    }
    
}

extension HabitManager{
    
    static func add(addedHabit: T , in realm: Realm = try! Realm(), completion: @escaping (RealmResult<T>) -> ()){
        
        do{
            try realm.write {
                realm.add(addedHabit)
                completion(.sucess(addedHabit))
            }
        }catch{
            completion(.error(error as! Realm.Error))
        }
    }
    
    // 알람 시간( 사용자 설정 알람 시간) : Realm에 있는걸 가져올거임.
    // completion
    
//    static func setAlarmInMyPhone() {
//
//        let app = UIApplication.shared
//        let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
//        app.registerUserNotificationSettings(notificationSettings)
//
//        let time : TimeZone = TimeZone(identifier: "Asia/Yakutsk")!
//        let date = Date(timeIntervalSinceNow: Double(time.secondsFromGMT()))
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
//
//        let currentTimeTransSeconds = (components.hour!+15)*3600 + components.minute!*60 + components.second!
//        let alarmTime = (SettingViewController.hour) * 3600 + SettingViewController.min * 60
//        var alertTime: NSDate = NSDate()
//        if currentTimeTransSeconds  > aramTime{// 현재시각 보다 알람시간이 작을때 -> 다음날 울림
//            alertTime = NSDate().addingTimeInterval(TimeInterval((86400-currentTimeTransSeconds)+aramTime))
//            print(currentTimeTransSeconds, aramTime,"- 값이 나옴니다 \(TimeInterval((86400-currentTimeTransSeconds)+aramTime))")
//        }else{// 알람시각이 현재시각보다 클때 -> 두 시각의 차 이후에 울림.
//            alertTime = NSDate().addingTimeInterval(TimeInterval(aramTime - currentTimeTransSeconds))
//            print(TimeInterval(aramTime-currentTimeTransSeconds))
//        }
//        //        alertTime = NSDate().addingTimeInterval(TimeInterval(alarmTime - currentTimeTransSeconds))
//        dump(alarmTime-currentTimeTransSeconds)
//
//        dump("알람 시간 : \(alertTime)")
//
//        let notifyAlarm = UILocalNotification()
//
//        notifyAlarm.fireDate = alertTime as Date
//        notifyAlarm.timeZone = NSTimeZone.default
//        notifyAlarm.soundName = "bell_tree.mp3"
//        notifyAlarm.alertBody = "일기쓸 시간입니다."
//        app.scheduleLocalNotification(notifyAlarm)
//    }
    
    static func getScheduledDay(startDay: String, endDay: String) -> (String, Bool){
        
        let startSeparateList: [String] = startDay.components(separatedBy: ". ")
        let endSeparateList:[String] = endDay.components(separatedBy: ". ")
        // 달이 다를 경우를 대비해서 아싸리 일단위로 계산하자
        let totalStartDay = Util.calculateTotalDate(dateList: startSeparateList)
        let totalEndDay = Util.calculateTotalDate(dateList: endSeparateList)
        
        print(totalStartDay, totalEndDay)
        // 연이 틀릴경우에는 ??
        // MARK:- Remain Job
        
        // 결과값, 결과값이 10일 미만일 경우..
        return ("\(totalEndDay-totalStartDay)", totalEndDay-totalStartDay < 10 ? true : false)
    }

}


