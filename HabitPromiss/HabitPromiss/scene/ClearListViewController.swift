//
//  ClearListViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 5. 24..
//  Copyright © 2018년 주호박. All rights reserved.

import UIKit
import RealmSwift

class ClearListViewController: BaseViewController {
    
    @IBOutlet weak var clearListTableView: UITableView!
    private var clearListCellIdentifier: String = "clearListCell"
    var clearLsit:Results<HabitManager>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // REalm의 HabitManager Object를 통해서 successPromiss 필드의 값이 true인 아이들만 컬렉션으로 불러옴. ( viewDidload)
        clearLsit = HabitManager.getRealmObjectList(filterStr: "sucessPromiss == true", sortedBy: HabitManager.Property.sucessPromiss)
    }
}

extension ClearListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
extension ClearListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clearLsit?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: clearListCellIdentifier, for: indexPath) as! ClearListCell
        cell.clearText.text = clearLsit?[indexPath.row].habitName
        return cell
    }
}
