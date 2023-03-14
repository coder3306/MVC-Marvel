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
    private var detailTask: MarvelCharactersDetailTaskInput?
    /// 이미지 다운로드 객체
    private var imageTask: ImageTaskInput?
    /// 테이블뷰 설정 정보 초기화
    private var tableConfig = ModelCollection<ComicsDetail>()
    /// 컬렉션뷰 섹션 여백 설정
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    /// 이미지 셀 인덱스 저장
    private var indexPathsForImageCells = [String]()
    
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
            self.detailTask?.requestDetailList(type: MarvelDetail.self, url: url, for: items?.available ?? 0)
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
        let detailTask = MarvelCharactersDetailTask(networkClient: NetworkManager())
        detailTask.output = self
        self.detailTask = detailTask
        
        let imageTask = ImageProvider(imageClient: NetworkManager())
        imageTask.output = self
        self.imageTask = imageTask
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
        return tableConfig.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarvelCharactersDetailCollectionViewCell", for: indexPath) as? MarvelCharactersDetailCollectionViewCell {
            guard let items = tableConfig.elements, items.isEmpty == false else { return UICollectionViewCell() }
            let item = items[indexPath.row]
            cell.imgCharactesDetail?.image = cache.object(forKey: item.thumbnail.thumbnailURL as NSString)
            cell.setData(item)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let itemsPerColumn: CGFloat = 3
        let cellWidth = (collectionView.frame.width - (sectionInsets.left * (itemsPerRow + 1))) / itemsPerRow
        let cellHeight = (collectionView.frame.height - (sectionInsets.top * (itemsPerColumn + 1))) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

//MARK: - Output
extension MarvelCharacterDetailViewController: MarvelCharactersDetailTaskOutput, ImageTaskOutput {
    /**
     * @캐릭터 상세보기 데이터 저장 및 UI 업데이트
     * @creator : coder3306
     * @param item : 캐릭터 상세정보
     */
    func responseDetailList(_ item: MarvelDetail?) {
        if let item {
            self.tableConfig.elements = item.data.results
            item.data.results.forEach({ characters in
                indexPathsForImageCells.append(characters.thumbnail.thumbnailURL)
                self.imageTask?.requestImage(from: characters.thumbnail.thumbnailURL)
            })
            self.collectionCharactersDetail?.reloadData()
        } else {
            self.tableConfig.elements = nil
        }
    }
    
    /**
     * @요청된 캐릭터 이미지 캐싱처리
     * @creator : coder3306
     * @param image : 요청된 이미지
     * @param urlString : 이미지 다운로드 주소
     */
    func responseImage(_ image: UIImage?, to urlString: String) {
        if let image {
            cache.setObject(image, forKey: urlString as NSString)
            self.updateImageCell(to: image, for: urlString)
        }
    }
    
    /**
     * @요청된 캐릭터 이미지 업데이트
     * @creator : coder3306
     * @param image : 다운로드된 이미지
     * @param urlString : 이미지 다운로드 주소
     */
    func updateImageCell(to image: UIImage?, for urlString: String) {
        let index = indexPathsForImageCells.firstIndex(of: urlString) ?? 0
        if let cell = self.collectionCharactersDetail?.cellForItem(at: IndexPath(item: index, section: 0)) as? MarvelCharactersDetailCollectionViewCell {
            let width = cell.imgCharactesDetail?.frame.size.width ?? .zero
            let height = cell.imgCharactesDetail?.frame.size.height ?? .zero
            
            if let resizeImage = image?.resizeImage(newSize: CGSize(width: width, height: height)) {
                cell.imgCharactesDetail?.image = resizeImage
            } else {
                cell.imgCharactesDetail?.image = image
            }
        }
    }
}
