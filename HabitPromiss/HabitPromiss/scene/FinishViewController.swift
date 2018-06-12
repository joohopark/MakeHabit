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
    
    fileprivate var documentController: UIDocumentInteractionController?
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var habitName: UILabel!

    @IBOutlet weak var pieChart: PieChartView!

    @IBAction func didTapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapedShared(_ sender: UIButton) {
        
        let imageToShare = takeScreenshot()
        
        let activityItems : NSMutableArray = []
        activityItems.add(imageToShare!)
        
        
        let activityVC = UIActivityViewController(activityItems:activityItems as [AnyObject] , applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
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
    
    // 스샷을 photo App으로 보냄.
    // 리턴으로 뺄수도 있고 해서
    // 저장 완료후 카톡으로 보내기 가능.
    func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        // 결과 저장 프로퍼티
        var screenshotImage :UIImage?
        // 사이즈
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
struct MessageTemplateConstants {
    static let customTemplateID = "3135"
    
}

extension FinishViewController {
    
    func showChooseSharingFile() {
        UIAlertController.showAlert(title: "", message: "공유 파일?", actions: [
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil),
            UIAlertAction(title: "JPG", style: .default, handler: { (alertAction) in
                self.shareFile(Bundle.main.url(forResource: "screen", withExtension: "png"))
            })
            ])
    }
    
    func shareFile(_ localPath: URL?) {
        if let localPath = localPath {
            documentController = UIDocumentInteractionController(url: localPath)
            documentController?.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
        }
    }
    
    func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
        self.documentController = nil
    }
    
    func drowPieChart() {
        pieChart.data = chart
        pieChart.entryLabelFont = UIFont(name: "NanumPen", size: 16)
        pieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)
        self.pieChart.data?.notifyDataChanged()
    }
}

