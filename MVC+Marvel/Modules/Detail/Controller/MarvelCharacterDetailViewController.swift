//
//  MarvelCharacterDetailViewController.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/12.
//

import UIKit

class MarvelCharacterDetailViewController: CommonViewController {
    @IBOutlet private weak var collectionCharactersDetail: UICollectionView? {
        didSet {
            collectionCharactersDetail?.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        }
    }
    
    var items: Comics?
    var charactersInfo: CharactersInfo?
    private var model: MarvelCharactersDetailTaskInput?
    private var tableConfig = CommonConfig<MarvelDetail>()
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionViewcell()
        bindModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
        if let url = items?.collectionURI {
            self.model?.requestDetailList(type: MarvelDetail.self, url: url, limit: items?.available ?? 0)
        }
    }
    
    private func setNavigationBar() {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        let naviItems = NavigationBarItems(title: charactersInfo?.title, leftBarButton: [btn])
        initNavigationBar(naviItems: naviItems)
    }
    
    private func bindModel() {
        let model = MarvelCharactersDetailTask()
        model.output = self
        self.model = model
    }
}

//MARK: - collectionViewExtension
extension MarvelCharacterDetailViewController: collectionViewExtension {
    private func initCollectionViewcell() {
        if let collectionCharactersDetail {
            MarvelCharactersDetailCollectionViewCell.registerXib(targetView: collectionCharactersDetail)
        }
    }
    
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
