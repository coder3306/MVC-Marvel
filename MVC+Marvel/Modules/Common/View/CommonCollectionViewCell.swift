//
//  CommonCollectionViewCell.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/16.
//

import UIKit

class CommonCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func requestImage(url: String, complete: @escaping (UIImage) -> ()) {
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shared.downloadImage(url: url) { image in
                if let image {
                    complete(image)
                }
            }
        }
    }
}
