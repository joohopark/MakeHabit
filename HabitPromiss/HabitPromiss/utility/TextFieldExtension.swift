//
//  TextFieldExtension.swift
//  HabitPromiss
//
//  Created by 배지호 on 2018. 6. 11..
//  Copyright © 2018년 주호박. All rights reserved.
//

import Foundation

extension UIViewController {
  //뷰 터치하면 키보드 내리는 코드
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
