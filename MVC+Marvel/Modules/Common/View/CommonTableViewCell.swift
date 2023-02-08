//
//  CommonTableViewCell.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import UIKit

class CommonTableViewCell: UITableViewCell {
    
//    private var networkClient: NetworkClient?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func requestImage(url: String, complete: @escaping dataHandler<UIImage>) {
//        DispatchQueue.global(qos: .background).async {
//            NetworkManager.shared.downloadImage(url: url) { image in
//                if let image {
//                    complete(image)
//                }
//            }
//        }
    }
}
