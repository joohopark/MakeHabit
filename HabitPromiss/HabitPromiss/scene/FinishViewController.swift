//
//  FinishViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 6. 8..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class FinishViewController: UIViewController {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var habitName: UILabel!
    @IBOutlet weak var persent: UILabel!
    
    @IBOutlet weak var pieChart: PieChartView!
      var chart:PieChartData!
    
    var userData: UserInfo!
    var clearData: HabitManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("넘어왔어",userData?.nickName, clearData?.habitName)
        
        if let unUserData = userData, let unClearData = clearData{
            userName.text = unUserData.nickName
            habitName.text = unClearData.habitName
        }
        persent.text = "\(clearData.currentCount/clearData.totalCount*100)%"
    print(clearData.currentCount/clearData.totalCount*100)
        
    }
    
    

    @IBAction func didTapDissMiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPushedSharedButton(_ sender: UIButton) {
//        takeScreenshot()
        sendLinkCustom() 
    }
    
    // 스샷을 photo App으로 보냄.
    // 리턴으로 뺄수도 있고 해서
    // 저장 완료후 카톡으로 보내기 가능.
    func takeScreenshot(_ shouldSave: Bool = true){//} -> UIImage? {
        // 결과 저장 프로퍼티
        var screenshotImage :UIImage?
        // 사이즈
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return }//nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
//        return screenshotImage
    }
    
    func sendLinkCustom() -> Void {
        
        // 템플릿 ID
        let templateId = MessageTemplateConstants.customTemplateID
        // 템플릿 Arguments
        let templateArgs = ["title": "제목 영역입니다.",
                            "description": "설명 영역입니다."]
        
        KLKTalkLinkCenter.shared().sendCustom(withTemplateId: templateId, templateArgs: templateArgs, success: { (warningMsg, argumentMsg) in
            
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")
            
        }, failure: { (error) in
            
            // 실패
            Util.showMessage(error.localizedDescription)
            print("error \(error)")
            
        })
    }
}

struct MessageTemplateConstants {
    static let customTemplateID = "3135"
}
