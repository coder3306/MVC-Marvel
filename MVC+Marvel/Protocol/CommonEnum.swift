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

