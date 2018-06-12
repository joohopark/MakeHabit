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
    
    @objc dynamic var startDate: String = ""
    @objc dynamic var endDate: String = ""
    
    // 약속 -> 성공 뷰로 넘어갈지에 대한 여부
    // totalCount == currentCount 가 될경우 true
    @objc dynamic var sucessPromiss: Bool = false
    
    // 사용자 지정 알람 시간
    // picker를 통해 입력된 사용자 알림 시간임
    @objc dynamic var alarmTime: String = ""
    
    // 사용자가 지정한 Icon 번호
    // 컬렉션뷰를 선택했을때의 item No
    @objc dynamic var iConNo: String = ""
    
    // 사용자가 선택한 켈린더의 날짜
    // 켈린더 컬렉션 뷰의 데이터 들의 [Date]
    // Date를 그냥 때려 박진 못함 Realm은 primitive type만을 원한다...
    var promissDate =  List<String>()// 사용자들이 켈린더에서 선택한 날짜 목록
    // 렘에서 리스트는 여기서 초기화를 해주고 따로 init등에서 작업을 안해줘도 된다.
    
    var goalDate = List<String>()
    
    convenience init(_ habitName: String, totalCount: Int, currentCount: Int,
                     planedPiriod: String = "", startDay: String = "", endDay: String = "",sucessPromiss: Bool = false, alarmTime: String = "",
                     iConNo: String) {
        self.init()
        self.habitName = habitName
        self.totalCount = totalCount
        self.currentCount = currentCount
        self.planedPiriod = planedPiriod
        self.startDate = startDay
        self.endDate = endDay
        self.sucessPromiss = sucessPromiss
        self.alarmTime = alarmTime
        // icon 번호는 CollectionView를 눌렀을때만 확인이 가능한다.
        self.iConNo = iConNo
        
//        promissDate =
        
    }
    
    override static func primaryKey() -> String? {
        return Property.id.rawValue
    }
    
}

extension HabitManager{
    // 램 개체에 값을 쓴다.( 추가한다)
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
    
    // 필터에 해당하는 램 개체의 모든 필드를 정렬하여 반환
    static func getRealmObjectList(filterStr: String, sortedBy: Property, in realm: Realm = try! Realm()) -> Results<T>{
        return realm.objects(T.self).filter(filterStr).sorted(byKeyPath: sortedBy.rawValue)
    }
    static func getRealmObjectListWithoutSorted(filterStr: String, in realm: Realm = try! Realm()) -> Results<T>{
        return realm.objects(T.self).filter(filterStr)
    }
    
    static func updateSucessPromiss(realmItem: HabitManager, in realm: Realm = try! Realm()){
        let item = realmItem
        try! realm.write {
            item.sucessPromiss = true
            realm.add(item)
        }
    }
    
    // 알람시간을 초로 바꿔 반환한다. ------------ 안씀.
    static func alarmTimeConvertSecond(inSeconds: String) -> Double{
        let inSecondsList = inSeconds.components(separatedBy: ":")
        let hour = Double(inSecondsList[0])
        let min = Double(inSecondsList[1])
        return hour!*3600+min!*60
    }
    
    static func getScheduledDay(startDay: String, endDay: String) -> (String, Bool){
        
        let startSeparateList: [String] = startDay.components(separatedBy: ". ")
        let endSeparateList:[String] = endDay.components(separatedBy: ". ")
        // 달이 다를 경우를 대비해서 아싸리 일단위로 계산하자
        let totalStartDay = Util.calculateTotalDate(dateList: startSeparateList)
        let totalEndDay = Util.calculateTotalDate(dateList: endSeparateList)
        
        print(totalStartDay, totalEndDay)
        // 연이 틀릴경우에는 ??
        // MARK:- Remain Job
        
        // 결과값, 결과값이 30일 초과일 경우..
        // +1 한 이유는 약속을 생성한 그 당일 또한 추가를 해야 되기 때문임...
        
        return ("\(totalEndDay-totalStartDay+1)", totalEndDay-totalStartDay > 30 ? true : false)
        
//        switch totalEndDay-totalStartDay {
//        case 30...:
//            return ("\(totalEndDay-totalStartDay)",false)
//        case 0:
//            return
//        default:
//            return ("\(totalEndDay-totalStartDay)",true)
//        }
    }
    
    // goalDate 리스트는 켈린더를ㄹ 눌렀을때 생성된다.. 첫 실행시 문제가됨.
    // 
    static func shouldPerFormAppendDatePromissList(promis: T, passDateList: [Date], goalDateList: [Date],in realm: Realm = try! Realm()){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
//        let list = realm.objects(T.self)
        do{
        try realm.write {
            promis.goalDate.removeAll()
                for date in goalDateList{// 다 지우고 들어온애들을 다시 넣어줘
                   promis.goalDate.append(formatter.string(from: date))
                }
                promis.totalCount = promis.goalDate.count
            print("totalCount : \(promis.goalDate.count)들어갔어~")
                promis.promissDate.removeAll()
                for date in passDateList{
                    promis.promissDate.append(formatter.string(from: date))
                }
                promis.currentCount = promis.promissDate.count
            print("currentCount : \(promis.promissDate.count) 들어갔어~")
            }
            print(promis.goalDate, promis.promissDate, "왜그러눈고야!!!!")
        }catch let error{
            print(error.localizedDescription)
        }
    }

//    static func shouldPerFormRemoveDatePromissList(index: Int, passDate: Date, goalDateList: [Date],in realm: Realm = try! Realm()){
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let list = realm.objects(T.self)[index]
//        do{
//            try realm.write {
//                list.goalDate.removeAll()
//                for date in goalDateList{
//                    list.goalDate.append(formatter.string(from: date))
//                }
//                list.promissDate.removeAll()
//                list.promissDate.append(formatter.string(from: passDate))
//            }
//        }catch let error{
//            print(error.localizedDescription)
//        }
//
//    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}

