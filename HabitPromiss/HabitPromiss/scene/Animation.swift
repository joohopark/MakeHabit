//
//  TextFieldAnimation.swift
//  HabitPromiss
//
//  Created by 배지호 on 2018. 5. 31..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit
//MARK:- TextField buttom

extension UITextField {
  //TextField bottom
  func borderBottom(height: CGFloat, color: UIColor) {
    let border = CALayer()
    border.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: height)//border 크기 설정
    border.backgroundColor = color.cgColor
    self.layer.insertSublayer(border, at: 0)
  }
  //TextField bottom shake
  func shake() {
    let originalXValue = self.center.x
    UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [.autoreverse], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: {
        self.center.x -= 10
      })
      UIView.addKeyframe(withRelativeStartTime: 0.20, relativeDuration: 0.50, animations: {
        self.center.x += 15
      })
      UIView.addKeyframe(withRelativeStartTime: 0.70, relativeDuration: 0.25, animations: {
        self.center.x -= 15
      })
    }, completion: { _ in
      self.center.x = originalXValue
    })
  }
}

extension UIView {
  func animationView() {
    
  }
}
