//
//  MarvelCharactersTableViewCell.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import UIKit

enum CharactersInfo: Int {
    case comics = 0
    case series
    case events
    case none
    
    init(type: Int) {
        switch type {
            case 0: self = .comics
            case 1: self = .series
            case 2: self = .events
            default: self = .none
        }
    }
    var code: Int {
        return rawValue
    }
}

class MarvelCharactersTableViewCell: CommonTableViewCell {
    @IBOutlet private weak var imgThumbnail: UIImageView?
    @IBOutlet private weak var lblDescription: UILabel?
    @IBOutlet private weak var lblName: UILabel?
    @IBOutlet private weak var lblComicsCount: UILabel?
    @IBOutlet private weak var lblSeriesCount: UILabel?
    @IBOutlet private weak var lblEventsCount: UILabel?
    @IBOutlet weak var detailView: UIStackView?
    @IBOutlet private var detailItemView: [UIView]?
    
    // 선택된 캐릭터 데이터 전달 핸들러
    private var selectHandler: dataHandler<CharactersInfo>?
    // 상세보기 버튼 선택 핸들러
    private var actionHandler: boolHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailItemView?.forEach({
            
            $0.layer.setBorderLayout(radius: 10)
        })
    }
    
    public func setData(_ result: Result, with cache: NSCache<NSString, UIImage>) {
        self.lblName?.text = result.name
        self.lblDescription?.text = result.description
        self.lblComicsCount?.text = "\(result.comics.available) 회"
        self.lblSeriesCount?.text = "\(result.series.available) 회"
        self.lblEventsCount?.text = "\(result.events.available) 회"
        let imageURL = result.thumbnail.thumbnailURL
        if let image = cache.object(forKey: imageURL as NSString) {
            print("Cache -------------->>>>> \(image)")
            self.imgThumbnail?.image = image
        } else {
            requestImage(url: imageURL) { image in
                print("Download -------------->>>>> \(image)")
                self.imgThumbnail?.image = image
                cache.setObject(image, forKey: imageURL as NSString)
            }
        }
    }
    
    public func didSelectCharactersInfo(_ complete: @escaping dataHandler<CharactersInfo>) {
        self.selectHandler = complete
    }
    
    public func didSelectDetail(_ complete: @escaping boolHandler) {
        self.actionHandler = complete
    }
}

//MARK: - Action
extension MarvelCharactersTableViewCell {
    @IBAction private func actionSelectCharactersInfo(_ sender: UIButton) {
        self.selectHandler?(CharactersInfo(type: sender.tag))
    }
    
    @IBAction private func actionShowDetail(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.actionHandler?(sender.isSelected)
    }
}
