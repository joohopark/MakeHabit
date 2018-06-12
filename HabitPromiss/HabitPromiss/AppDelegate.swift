//
//  AppDelegate.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 24..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    //런치 스크린 0.5초 이후에 꺼지도록..
    Thread.sleep(forTimeInterval: 0.5)
    
    // 로컬 노티 알람 옵션이 Allow 안되있을 경우 딜리게이트를 통해 그 알랏을 띄운다.
    UNUserNotificationCenter.current().delegate = self
    return true
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if KLKTalkLinkCenter.shared().isTalkLinkCallback(url) {
      let params = url.query
      UIAlertController.showMessage("카카오링크 메시지 액션\n\(params ?? "파라미터 없음")")
      return true
    }
    return false
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    if KLKTalkLinkCenter.shared().isTalkLinkCallback(url) {
      let params = url.query
      UIAlertController.showMessage("카카오링크 메시지 액션\n\(params ?? "파라미터 없음")")
      return true
    }
    return false
  }
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
  // 로컬 노티를 띄우기 위해서 확인 알랏을 띄우는 거임.
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.alert)
  }
}
