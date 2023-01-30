//
//  CommonEnum.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation

public enum ApiResult<T> {
    case success(T)
    case failure(ApiError)
}

public enum ApiError: Error {
    case invalidURL
    case encodingError
    case statusCodeError
    case imageConvertingError
    case emptyData

    var errorDescription: String {
        switch self {
            case .invalidURL:
                return "유효하지 않은 URL 입니다."
            case .statusCodeError:
                return "홈페이지의 응답이 없습니다."
            case .imageConvertingError:
                return "이미지 다운로드에 실패하였습니다."
            case .emptyData:
                return "데이터가 없습니다."
            case .encodingError:
                return "인코딩에 실패하였습니다."
        }
    }
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
