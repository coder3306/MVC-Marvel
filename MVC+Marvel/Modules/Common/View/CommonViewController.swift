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
    /// 커스텀 네비게이션 바 초기화
    let customNavigationBar = CustomNavigationBar()
    /// 이미지 캐시
    var cache = NSCache<NSString, UIImage>()
    
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
        cache.removeAllObjects()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        cache.removeAllObjects()
    }
    
    //******************************************************
    //MARK: - NavigationBar Setting
    //******************************************************
    public func initNavigationBar(naviItems: NavigationBarItems) {
        /// 기본 네비게이션바 숨기기
        self.navigationController?.navigationBar.isHidden = true
        self.customNavigationBar.backgroundColor = .white
        customNavigationBar.setNavigationBar(naviItems.title, leftBarButton: naviItems.leftBarButton, rightBarButton: naviItems.rightBarButton)
        customNavigationBar.navigationTitleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        self.view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customNavigationBar.containerView)
        }
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
