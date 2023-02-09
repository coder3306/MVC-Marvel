//
//  MarvelCharacterDetailViewController.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/12.
//

import UIKit

class MarvelCharacterDetailViewController: CommonViewController {
    /// 캐릭터 상세보기 컬렉션 뷰
    @IBOutlet private weak var collectionCharactersDetail: UICollectionView? {
        didSet {
            collectionCharactersDetail?.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        }
    }
    
    //******************************************************
    //MARK: - Properties
    //******************************************************
    /// 상세보기 데이터
    var items: Comics?
    /// 상세보기 캐릭터 정보
    var charactersInfo: CharactersInfo?
    /// 모델 데이터
    private var model: MarvelCharactersDetailTaskInput?
    /// 테이블뷰 설정 정보 초기화
    private var tableConfig = CommonConfig<MarvelDetail>()
    /// 컬렉션뷰 섹션 여백 설정
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    //******************************************************
    //MARK: - ViewController LifeCycle
    //******************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionViewcell()
        bindModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
        if let url = items?.collectionURI {
            self.model?.requestDetailList(type: MarvelDetail.self, url: url, for: items?.available ?? 0)
        }
    }
    
    //******************************************************
    //MARK: - Instance
    //******************************************************
    /**
     * @네비게이션 바 설정
     * @creator : coder3306
     */
    private func setNavigationBar() {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        let naviItems = NavigationBarItems(title: charactersInfo?.title, leftBarButton: [btn])
        initNavigationBar(naviItems: naviItems)
    }
    
    /**
     * @모델 바인딩
     * @creator : coder3306
     */
    private func bindModel() {
        let model = MarvelCharactersDetailTask(networkClient: NetworkManager())
        model.output = self
        self.model = model
    }
}

//MARK: - collectionViewExtension
extension MarvelCharacterDetailViewController: collectionViewExtension {
    /**
     * @테이블뷰 셀 초기화
     * @creator : coder3306
     */
    private func initCollectionViewcell() {
        if let collectionCharactersDetail {
            MarvelCharactersDetailCollectionViewCell.registerXib(targetView: collectionCharactersDetail)
        }
    }
    
    //******************************************************
    //MARK: - TableView Setting
    //******************************************************
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableConfig.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarvelCharactersDetailCollectionViewCell", for: indexPath) as? MarvelCharactersDetailCollectionViewCell {
            if let item = tableConfig.items?.first?.data.results[indexPath.row] {
                cell.setData(item, with: cache)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

//MARK: - Output
extension MarvelCharacterDetailViewController: MarvelCharactersDetailTaskOutput {
    /**
     * @캐릭터 상세보기 데이터 저장 및 UI 업데이트
     * @creator : coder3306
     * @param item : 캐릭터 상세정보
     */
    func responseDetailList(_ item: MarvelDetail?) {
        if let item {
            self.tableConfig.items = [item]
            self.tableConfig.cellCount = item.data.results.count
            self.collectionCharactersDetail?.reloadData()
        } else {
            self.tableConfig.items = nil
            self.tableConfig.cellCount = 0
        }
    }
}
