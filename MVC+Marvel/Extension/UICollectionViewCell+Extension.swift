//
//  UICollectionViewCell+Extension.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/16.
//

import UIKit

extension UICollectionViewCell {
    /// 재사용 셀 식별자
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    /**
     * @커스텀 xib 등록
     * @creator : coder3306
     * @param targetView : xib를 등록할 컬렉션 뷰
     */
    static func registerXib(targetView: UICollectionView) {
        let nib = UINib(nibName: self.reuseIdentifier, bundle: nil)
        targetView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
