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
    
    /**
     * @테이블뷰 확장 애니메이션
     * @creator : coder3306
     * @param subView : 확장 뷰
     * @param isExpanded : 확장 여부
     * @param indexPath : 셀 인덱스
     * @param tableView : 확장할 테이블뷰
     */
    func setExpandView(_ subView: UIView, isExpanded: Bool, index indexPath: IndexPath, tableView: UITableView) {
        subView.alpha = 0.0
        tableView.beginUpdates()
        UIView.animate(withDuration: 0.3) {
            subView.isHidden = !isExpanded
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                subView.alpha = 1.0
            }
        }
        tableView.endUpdates()
    }
}

