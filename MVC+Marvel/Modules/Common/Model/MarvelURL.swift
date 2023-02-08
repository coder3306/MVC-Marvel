//
//  MarvelURL.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/02/08.
//

import Foundation

enum MarvelURL {
    // 캐릭터 리스트
    case characterList
    /// 캐릭터 상세보기
    case characterDetail
    
    var resource: String {
        switch self {
            case .characterList:
                return "http://gateway.marvel.com/v1/public/characters"
            case .characterDetail:
                return ""
        }
    }
}
