//
//  CommonViewController.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import UIKit

/// 테이블뷰 확장 프로토콜
typealias tableViewExtension = UITableViewDelegate & UITableViewDataSource
/// 컬렉션뷰 확장 프로토콜
typealias collectionViewExtension = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

/// 데이터 전달 콜백 핸들러
typealias dataHandler<T> = (T?) -> ()
/// 불 데이터 전달 콜백 핸들러
typealias boolHandler = (Bool) -> ()

class CommonViewController: UIViewController {
    
    //******************************************************
    //MARK: - ViewController LifeCycle
    //******************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
