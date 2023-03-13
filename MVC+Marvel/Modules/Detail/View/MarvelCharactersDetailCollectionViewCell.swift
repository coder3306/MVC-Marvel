//
//  MarvelCharactersDetailCollectionViewCell.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/16.
//

import UIKit

class MarvelCharactersDetailCollectionViewCell: CommonCollectionViewCell {
    /// 캐릭터 상세보기 이미지
    @IBOutlet weak var imgCharactesDetail: UIImageView?
    /// 캐릭터 정보 라벨
    @IBOutlet private weak var lblCharactersInfo: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /**
     * 캐릭터 정보 설정
     * - Author: coder3306
     * - Parameters:
     *   - items : 캐릭터 정보 모델
     *   - cache : 이미지 캐싱
     */
    public func setData(_ items: ComicsDetail, with cache: NSCache<NSString, UIImage>) {
        lblCharactersInfo?.text = items.title
    }
}
