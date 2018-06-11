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
  @IBOutlet weak var persent: UILabel!
  
  @IBAction func kakaoLinkButton(_ sender: UIButton) {
//    showChooseSharingFile()
  }
  @IBOutlet weak var pieChart: PieChartView!
  var chart:PieChartData!
  
  var userData: UserInfo!
  var clearData: HabitManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    documentController?.delegate = self as! UIDocumentInteractionControllerDelegate
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
}

//extension FinishViewController {
//  
//  func showChooseSharingFile() {
//    UIAlertController.showAlert(title: "", message: "공유 파일?", actions: [
//      UIAlertAction(title: "Cancel", style: .cancel, handler: nil),
//      UIAlertAction(title: "JPG", style: .default, handler: { (alertAction) in
//        self.shareFile(Bundle.main.url(forResource: "test_img", withExtension: "jpg"))
//      })
//      ])
//  }
//
//  func shareFile(_ localPath: URL?) {
//    if let localPath = localPath {
//      documentController = UIDocumentInteractionController(url: localPath)
//      documentController?.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
//    }
//  }
//
//  func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
//    self.documentController = nil
//  }
//}
