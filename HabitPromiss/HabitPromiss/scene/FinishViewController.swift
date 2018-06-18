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

// 자랑 하기 , clear List 들에 detail View임.
class FinishViewController: UIViewController {
    
    fileprivate var documentController: UIDocumentInteractionController?
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var habitName: UILabel!

    @IBOutlet weak var pieChart: PieChartView!

    var chart:PieChartData!
    
    var userData: UserInfo!
    var clearData: HabitManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drowPieChart()
        documentController?.delegate = self as! UIDocumentInteractionControllerDelegate
        print("넘어왔어",userData?.nickName, clearData?.habitName)
        
        if let unUserData = userData, let unClearData = clearData{
            userName.text = unUserData.nickName
            habitName.text = unClearData.habitName
        }
        
    
    }
    

    
    // 스샷을 photo App으로 보냄.
    // 리턴으로 뺄수도 있고 해서
    // 저장 완료후 카톡으로 보내기 가능.
    func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        // 결과
        var screenshotImage :UIImage?
        // 스크린샷 사이즈 설정
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    
  
}

// MARK:- IBACtion Extension
extension FinishViewController{
    @IBAction func didTapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapedShared(_ sender: UIButton) {
        // 스샷을 사진첩에 저장 및 UIImage를 들고있는다.
        let imageToShare = takeScreenshot()
        
        let activityItems : NSMutableArray = []
        activityItems.add(imageToShare!)
        
        // 앱 표준 서비스 컨트롤러 생성 및 프레젠트를 통해 공유
        let activityVC = UIActivityViewController(activityItems:activityItems as [AnyObject] , applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
    }
}


extension FinishViewController {
    // 이거 프로토콜로 하나 묶어서 처리하든지 해야됨. 중복됨.
    func drowPieChart() {
        pieChart.data = chart
        pieChart.entryLabelFont = UIFont(name: "NanumPen", size: 16)
        pieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)
        self.pieChart.data?.notifyDataChanged()
    }
}

