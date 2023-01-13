//
//  CALayer+Extension.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/13.
//

import UIKit

extension CALayer {
    /**
     * @테두리 레이어 설정
     * @creator : coder3306
     * @param radius : 뷰의 모퉁이 부분을 설정한 값 만큼 둥글게 만듦
     * @param bounds : 설정할 뷰의 테두리를 기준으로 서브뷰의 레이아웃을 자를지 설정(default: true)
     * @param width : 뷰의 테두리 부분의 두께 설정
     * @param color : 뷰의 테두리 부분의 색상 설정
     */
    public func setBorderLayout(radius: CGFloat, bounds: Bool = true, width: CGFloat = 0, color: UIColor? = nil) {
        cornerRadius = radius
        masksToBounds = bounds
        borderWidth = width
        borderColor = color?.cgColor
    }
}
