//
//  String+Extension.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation
import CryptoKit

extension String {
    /**
     * @문자열 -> MD5 해시 변환
     * @creator : coder3306
     * @Return : 변환된 해시 데이터 반환
     */
    func md5() -> String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
