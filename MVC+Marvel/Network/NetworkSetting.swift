//
//  NetworkSetting.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation
import Alamofire

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
        self.header = [HTTPHeader(name: "Content-Type", value: "application/json")]
        
        let ts = "\(Date().timeIntervalSince1970)"
        guard let key = Bundle.getPlistKey(MarvelKeyDecoder.self) else { return nil }
        let hash = (ts + key.privateKey + key.publicKey).md5()
        self.parameter = ["limit": limit, "apikey": key.publicKey, "ts": ts, "hash": hash]
        return NetworkParameters(url: self.url, method: self.method, uri: nil, parameter: self.parameter, header: self.header)
    }
}
