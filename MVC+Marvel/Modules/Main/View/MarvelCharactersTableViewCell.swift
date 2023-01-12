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
    
    var selectHandler: (CharactersInfo) -> () = { _ in }
    var actionHandler: (Bool) -> () = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    public func didSelectCharactersInfo(_ complete: @escaping (CharactersInfo) -> ()) {
        self.selectHandler = complete
    }
    
    public func didSelectDetail(_ complete: @escaping (Bool) -> ()) {
        self.actionHandler = complete
    }
}

//MARK: - Action
extension MarvelCharactersTableViewCell {
    @IBAction private func actionSelectCharactersInfo(_ sender: UIButton) {
        print(sender.tag)
        self.selectHandler(CharactersInfo(type: sender.tag))
    }
    
    @IBAction private func actionShowDetail(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.actionHandler(sender.isSelected)
    }
}
