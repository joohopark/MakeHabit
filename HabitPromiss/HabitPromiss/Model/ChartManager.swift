//
//  ChartManager.swift
//  RealmPrac
//
//  Created by 주호박 on 2018. 5. 28..
//  Copyright © 2018년 주호박. All rights reserved.
//

import Foundation
import Charts
import RealmSwift
import UIKit

protocol ChartManagerType{
    // Realm 개체는 모두 사용할수 있도록 associatedtype 사용.
    associatedtype T: Object
    static func makePieChart(selectItem: T,completion: @escaping (RealmResult<ChartData>) -> ())// 입력값으로 인덱스 패스가 같이 들어와야 함,.. 무슨 약속에 대한 Chart인지 알려주기 위해 String 값이 같이 들어오면 좋을거 같다.
    static func getCurrentCountDataBase(indexPath: Int) -> T
}

// Pie 차트 만들어 주는 애
class ChartManager: ChartManagerType{
    //Realm 개체를 사용..
    typealias T = HabitManager
    static func makePieChart(selectItem: T, completion: @escaping (RealmResult<ChartData>) -> ()){
        var dataEntries: [PieChartDataEntry] = []
//        let currentCount = getCurrentCountDataBase(indexPath: indexPath)
        print(selectItem, "makePieChart" )
        
//        let dataEntry = PieChartDataEntry(value: Double(selectItem.promissDate.count))
        let dataEntry = PieChartDataEntry(value: Double(selectItem.currentCount))
        dataEntry.label = "현재까지의 습관 이행 횟수"
        
        let totalDataEntery = PieChartDataEntry(value: Double(selectItem.totalCount))
        totalDataEntery.label = "총 목표 횟수"
        
        dataEntries.append(contentsOf: [dataEntry, totalDataEntery])
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "\(selectItem.habitName)")// 여기에 무슨 약속에 대한 내용인지가 들어가면 좋을것 같다.
        let colors = [UIColor.red, UIColor.blue]
        chartDataSet.colors = colors
        let chartData = PieChartData(dataSet: chartDataSet)
        completion(.sucess(chartData))
      
    }
    
    static func getCurrentCountDataBase(indexPath: Int) -> T{
        do {
            let realm = try Realm()
            return realm.objects(HabitManager.self).filter("sucessPromiss == false")[indexPath]
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }

}
