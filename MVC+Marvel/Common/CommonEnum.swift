//
//  CommonEnum.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation
import Alamofire

public enum ApiResult<T> {
    case success(T)
    case failure(AFError)
}

enum CharactersInfo: Int {
    case comics = 0
    case series
    case events
    case none
    
    init(index: Int) {
        switch index {
            case 0: self = .comics
            case 1: self = .series
            case 2: self = .events
            default: self = .none
        }
    }
    var code: Int {
        return rawValue
    }
    
    var title: String {
        switch self {
            case .comics:
                return "Comics"
            case .series:
                return "Series"
            case .events:
                return "Events"
            case .none:
                break
        }
        return ""
    }
}
