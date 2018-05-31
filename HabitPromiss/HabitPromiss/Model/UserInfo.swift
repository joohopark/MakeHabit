//
//  UserInfo.swift
//  RealmPrac
//
//  Created by 주호박 on 2018. 5. 25..
//  Copyright © 2018년 주호박. All rights reserved.
//

import Foundation
import RealmSwift

protocol UserInfoType {
    associatedtype T: Object
    // 알람 여부에 대한 사용자 설정 switch
    static func didChangedAlarmValue(text: String, isOn: Bool, in realm: Realm, completion: @escaping (RealmResult<T>) -> ())
}


//UserDefault에 넣기엔 업데이트가 주기적으로 이뤄질 가능성이 있어보여서 사용자의 정보를 관리할 Realm 개체를 하나 생성해서 관리.

class UserInfo: Object, UserInfoType{
    typealias T = UserInfo
    // Class 내부에서 Property의 rawValue를 통해 설정을 돕기 위해
    enum Property: String {
        case id, nickName, alarmNeeded
    }
    
    // id : 후에 버전 업할떄 확장성을 위해 왠지 필요 할거 같아서 일단 기본키 역활을할 id 값을 하나 넣었음.
    // nickName : 사용자 푸쉬 올때 뭔가 자기 닉네임으로 불리면 기분좋을것 같다는 생각에..
    // alarmNeeded : 설정에서 사용자 알람을 이걸 보고 실행 한다. 기본값은 false
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var nickName: String = ""
    @objc dynamic var alarmNeeded: Bool = false
    
    // 위에 넣은 이유떄문에 기본키로 설정
    override static func primaryKey() -> String? {
        return Property.id.rawValue
    }

    convenience init(_ nickName: String) {
        self.init()
        self.nickName = nickName
    }
}

// MARK :- CRUD
// Result 는 Realm에서 직접 값을 갖고 있는 자료형이 아님. 연결해주는 통로 역활을 하는 클래스임.
extension UserInfo{
    // 어차피 이 메소드는 설정 뷰컨트롤러의 저장 버튼을 통해서만 호출이 될것으로 예상됨.
    // 사용자 설정 정보 저장 메소드
    static func didChangedAlarmValue(text: String, isOn: Bool = false, in realm: Realm = try! Realm(), completion: @escaping (RealmResult<T>) -> ()){
        if let user = realm.objects(UserInfo.self).first{// 값이 있을 경우( Realm에)
            do{
                try realm.write {
                    user.nickName = text
                    user.alarmNeeded = isOn// 알람 설정 여부만 변경.
                }
                completion(.sucess(user))
            }catch{
                completion(.error(error as! Realm.Error))
            }
        }else{// 값이 없을 경우
            let item = UserInfo(text)
            item.alarmNeeded = isOn
            do{
                try realm.write {
                    realm.add(item)
                }
                completion(.sucess(item))
            }catch{
                completion(.error(error as! Realm.Error))
            }
            
        }
    }
    
    static func getRealmObjectList( sortedBy: Property, in realm: Realm = try! Realm()) -> Results<T>{
        return realm.objects(T.self).sorted(byKeyPath: sortedBy.rawValue)
    }
}











