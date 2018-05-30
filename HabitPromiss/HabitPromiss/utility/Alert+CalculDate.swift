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
