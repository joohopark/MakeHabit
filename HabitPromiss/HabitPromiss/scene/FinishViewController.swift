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
    

}
