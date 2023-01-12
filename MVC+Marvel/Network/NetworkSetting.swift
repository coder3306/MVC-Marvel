//
//  NetworkSetting.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation
import Alamofire

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

public struct NetworkParameters {
    var url: String
    var method: HTTPMethod
    var uri: String?
    var parameter: [String: Any]?
    var header: HTTPHeaders?

    init(url: String, method: HTTPMethod, uri: String? = nil, parameter: [String : Any]? = nil, header: HTTPHeaders? = nil) {
        self.url = url
        self.method = method
        self.uri = uri
        self.parameter = parameter
        self.header = header
    }
}

extension NetworkParameters {
    /**
     * @마블 데이터 호출 네트워크 설정
     * @creator : coder3306
     */
    public mutating func getMarvelData(_ limit: Int) -> NetworkParameters? {
        self.url = "http://gateway.marvel.com/v1/public/characters"
        self.method = .get
        self.header = [HTTPHeader(name: "Content-Type", value: "application/json")]
        
        let ts = "\(Date().timeIntervalSince1970)"
        guard let key = Bundle.getPlistKey(MarvelKeyDecoder.self) else { return nil }
        let hash = (ts + key.privateKey + key.publicKey).md5()
        self.parameter = ["limit": limit, "apikey": key.publicKey, "ts": ts, "hash": hash]
        return NetworkParameters(url: self.url, method: self.method, uri: nil, parameter: self.parameter, header: self.header)
    }
}
