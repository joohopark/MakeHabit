//
//  IconCollectionViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 6. 2..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit

//MARK:- Description
//protocol IconCollectionViewType:class {
//    func setIconNo(selectCategory: Int, selectItem: Int)
//}
//PromissDetailViewController 가 부모인 Container View ,
// CollectionView를 부모 위에 올리기위해 만듦.
class IconCollectionViewController: BaseViewController {

    var prevIndexPath:[Int] = [0,0]
    var prevCell: IconCell?
 
    
    enum Category: Int{
        case health = 0
        case study
        case etc
        
        var count: Int{
            switch self {
            case .health:
                return 5
            case .study:
                return 5
            case .etc:
                return 10
            }
        }
        
        var name: String{
            switch self {
            case .health:
                return "health"
            case .study:
                return "study"
            case .etc:
                return "etc"
            }
        }
    }
    
    //MARK:- IBOutlet Hook up
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Property
    let categoryList = ["Heath",
                        "Study",
                        "ETC"
    ]
    
    
    var selectCategoryNo = 0
    var selectItemNo = 0
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "IconCell", bundle: nil),
                                forCellWithReuseIdentifier: "IconCell")
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
    }
    
    

    
}

extension IconCollectionViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return Category.health.count
        case 1:
            return Category.study.count
        case 2:
            return Category.etc.count
        default:
            print("check categoryList Value .., \(categoryList)")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as! IconCell
        switch indexPath.section {
        case Category.health.rawValue:
            cell.imgView.image = UIImage(named: "\(Category.health.name)_\(indexPath.item+1)")
        case Category.study.rawValue:
            cell.imgView.image = UIImage(named: "\(Category.study.name)_\(indexPath.item+1)")
        case Category.etc.rawValue:
            cell.imgView.image = UIImage(named: "\(Category.etc.name)_\(indexPath.item+1)")
        default:
            print("chack cellForItemAt")
        }
        
        if !cell.isSelected{
            cell.isSelected = true
            cell.imgView.alpha = 1
        }
        print(indexPath,"왜 범위 밖???")

        return cell
    }
    
    // 헤더도 재사용을 합니다. 컬렉션 뷰는..
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "IconCategoryHeaderView", for: indexPath) as! IconCategoryHeaderView
        var headerName = "", headerImageName = ""
        switch indexPath.section {
        case Category.health.rawValue:
            headerName = Category.health.name
        case Category.study.rawValue:
            headerName = Category.study.name
        case Category.etc.rawValue:
            headerName = Category.etc.name
        default:
            break
        }
        headerImageName = headerName+"_\(indexPath.section+1)"
        header.headerImgae.image = UIImage(named: headerImageName)
        header.headerName.text = headerName
            print("여길 타긴함????")
            return header

    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didDeselected\(indexPath)")
        
//            let cell = collectionView.cellForItem(at: indexPath) as? IconCell
//            
//            if (cell?.isSelected)!{
//                cell?.isSelected = false
//                cell?.imgView.alpha = 0.3
//            }else{
//                cell?.isSelected = true
//                cell?.imgView.alpha = 1
//            }
        
        print("didDeselected End")
    }
 
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        print("shouldDeSelected")
        
        return true
    }
    
    // 처음에는 isSelected값은 false , Cell 들
    // 눌리면 true
    // 다른게 눌리면 자동적으로 false로 이전 값이 바뀌어야 한다.
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print("shouldSelectItemAt")
        let cell = collectionView.cellForItem(at: indexPath) as! IconCell
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
//        // section, item 을 통해 iconNo를 표시해야한다.
        selectCategoryNo = indexPath.section
        selectItemNo = indexPath.row
        
        let cell = collectionView.cellForItem(at: indexPath) as! IconCell

        if !cell.isSelected{
            cell.isSelected = true
            cell.imgView.alpha = 1
        }else{
            cell.isSelected = false
            cell.imgView.alpha = 0.3
        }
        for index in 0..<indexPath.count{
            prevIndexPath[index] = indexPath[index]
        }
        if prevCell != nil{
            switch prevCell?.isSelected{
            case true:
                prevCell?.isSelected = false
                prevCell?.imgView.alpha = 0.3
            case false:
                prevCell?.isSelected = true
                prevCell?.imgView.alpha = 1
            case .none:
                print("none?")
            case .some(_):
                print("some?")
            }
        }
//
//        print(indexPath, "선택됨")
        
        prevCell = cell
        print("didSelected End")
    }

}

//MARK: - extension UICollectionViewDelegateFlowLayout
extension IconCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        let itemSpacing = Metric.itemSpacing * (Metric.numberOfItem - 1)
        let horizontalPadding = Metric.leftPadding + Metric.rightPadding
        let width = (collectionView.frame.width - itemSpacing - horizontalPadding) / Metric.numberOfItem
        return CGSize(width: width, height: width)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {
        return Metric.lineSpacing
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
        ) -> CGFloat {
        return Metric.itemSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
        ) -> UIEdgeInsets {
        return UIEdgeInsetsMake(Metric.topPadding, Metric.leftPadding,
                                Metric.bottomPadding, Metric.rightPadding)
    }
}

private struct Metric {
    // collectionView
    static let numberOfItem: CGFloat = 3

    static let leftPadding: CGFloat = 10.0
    static let rightPadding: CGFloat = 10.0
    static let topPadding: CGFloat = 10.0
    static let bottomPadding: CGFloat = 10.0

    static let itemSpacing: CGFloat = 5.0
    static let lineSpacing: CGFloat = 5.0
}








