//
//  BaseViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 24..
//  Copyright © 2018년 주호박. All rights reserved.

import UIKit
import UserNotifications

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setLocalNotification()
    }
    
    // setupUI를 통해 뷰컨트롤러에서 항상 뷰에대한 프레임 설정 등을 진행 하기 때문에
    // OOP 적 구현을 위해 생성.
    func setupUI() {
        // Override
    }
    
    // 애플의 정책상 requestAuthorization을 통해서 인증을 받아야 한다.
    private func setLocalNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (sucess, error) in
            if error != nil{
                print("Auth fail")
            }else{
                print("Auth sucess")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        // print("\(self) did Receive Memory Warning")
    }
    
    // deinit 나중에 필요 할수도 있응게.
    deinit {
        // print("\(self) has deinitialized")
    }
}
