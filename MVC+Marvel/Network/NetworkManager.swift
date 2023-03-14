//
//  NetworkManager.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation
import Alamofire

protocol NetworkClient {
    func requestData(param: NetworkParameters, completion: @escaping (ApiResult<Data>) -> ())
}

protocol ImageClient {
    func downloadImage(from urlString: String, completion: @escaping (ApiResult<Data>) -> ())
}

final class NetworkManager: NetworkClient, ImageClient {
    /**
     * @서버의 데이터를 요청합니다.
     * @creator : coder3306
     * @param type : 다운로드할 JSON 데이터에 매핑할 모델 설정
     * @param param : Alamofire Request 파라미터 설정
     * @Return : 성공 -> 매핑된 데이터 클로저 반환, 실패 -> 에러타입 반환
     */
    public func requestData(param: NetworkParameters, completion: @escaping (ApiResult<Data>) -> ()) {
        AF.request(param.url
                  , method: param.method
                  , parameters: param.parameter
                  , headers: param.header)
        .validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     * @이미지 데이터를 요청합니다.
     * @creator : coder3306
     * @param url : 이미지 다운로드 주소
     * @Return : 다운로드된 이미지 데이터 반환
     */
    public func downloadImage(from urlString: String, completion: @escaping (ApiResult<Data>) -> ()) {
        AF.request(urlString, method: .get)
            .validate()
            .responseData { response in
                switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                }
        }
    }
}
