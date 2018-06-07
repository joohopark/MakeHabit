//
//  IconCollectionViewController.swift
//  HabitPromiss
//
//  Created by 주호박 on 2018. 6. 2..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit

//MARK:- Description

//PromissDetailViewController 가 부모인 Container View ,
// CollectionView를 부모 위에 올리기위해 만듦.
class IconCollectionViewController: BaseViewController {

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
        print(indexPath)
        return cell
    }
    
    // 헤더도 재사용을 합니다. 컬렉션 뷰는..
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
//        switch kind {
//        case UICollectionElementKindSectionHeader:
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
//        default:
//            return UICollectionReusableView()
//        }
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









