//
//  Bundle+Extension.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation

extension Bundle {
    static let keyName = "MarvelKey"
    
    /**
     * @번들 키 값 매핑 후 호출
     * @creator : coder3306
     * @Return : 성공 -> 매핑된 키 값 반환, 실패 -> nil 반환
     */
    static func getPlistKey<T>(_ model: T.Type) -> T? where T: Decodable {
        guard let url = Bundle.main.url(forResource: Bundle.keyName, withExtension: "plist") else { return nil }
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(model.self, from: data)
        } catch {
            return nil
        }
    }
}
