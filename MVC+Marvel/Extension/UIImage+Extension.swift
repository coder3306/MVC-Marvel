//
//  UIImage+Extension.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/02/13.
//

import UIKit

extension UIImage {
    /**
     * @이미지 리사이즈
     * @creator : coder3306
     * @param image : 설정할 이미지
     * @param newWidth : 새로 설정할 이미지 너비
     * @Return : 생성된 이미지 반환
     */
    func resizeImage(newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
