//
//  MarvelCharactersDetailCollectionViewCell.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/16.
//

import UIKit

class MarvelCharactersDetailCollectionViewCell: CommonCollectionViewCell {
    @IBOutlet private weak var imgCharactesDetail: UIImageView?
    @IBOutlet private weak var lblCharactersInfo: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func setData(_ items: ComicsDetail, with cache: NSCache<NSString, UIImage>) {
        lblCharactersInfo?.text = items.title
        
        let imageURL = items.thumbnail.thumbnailURL
        
        if let image = cache.object(forKey: imageURL as NSString) {
            print("Cache Image -------------- >>>>> \(image)")
        } else {
            requestImage(url: imageURL) { image in
                if let image {
                    print("Download -------------->>>>> \(image)")
                    self.imgCharactesDetail?.image = image
                    cache.setObject(image, forKey: imageURL as NSString)
                }
            }
        }
    }
}
