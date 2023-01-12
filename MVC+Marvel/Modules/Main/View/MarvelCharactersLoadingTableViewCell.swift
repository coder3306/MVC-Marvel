//
//  MarvelCharactersLoadingTableViewCell.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/11.
//

import UIKit

class MarvelCharactersLoadingTableViewCell: CommonTableViewCell {
    @IBOutlet private weak var pagingIndicatorView: UIActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func loadingStart() {
        pagingIndicatorView?.startAnimating()
    }
}
