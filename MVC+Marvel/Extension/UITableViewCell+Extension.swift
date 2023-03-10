//
//  UITableViewCell+Extension.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/11.
//

import UIKit

extension UITableViewCell {
    /// 재사용 셀 식별자
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    /**
     * @커스텀 xib 등록
     * @creator : coder3306
     * @param targetView : xib를 등록할 테이블 뷰
     */
    static func registerXib(targetView: UITableView) {
        let nib = UINib(nibName: self.reuseIdentifier, bundle: nil)
        targetView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
}

