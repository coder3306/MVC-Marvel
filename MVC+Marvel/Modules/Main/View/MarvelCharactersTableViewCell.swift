//
//  MarvelCharactersTableViewCell.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import UIKit

class MarvelCharactersTableViewCell: CommonTableViewCell {
    @IBOutlet private weak var imgThumbnail: UIImageView?
    @IBOutlet private weak var lblDescription: UILabel?
    @IBOutlet private weak var lblName: UILabel?
    @IBOutlet private weak var lblComicsCount: UILabel?
    @IBOutlet private weak var lblSeriesCount: UILabel?
    @IBOutlet private weak var lblEventsCount: UILabel?
    
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
}
