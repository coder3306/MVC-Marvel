//
//  NetworkManager.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation
import Alamofire

final class NetworkManager: NSObject {
    /// 네트워크 데이터 요청 싱글톤 객체
    static let shared = NetworkManager()
    
    private override init() { }
    
    /**
     * @서버의 데이터를 요청합니다.
     * @creator : coder3306
     * @param type : 다운로드할 JSON 데이터에 매핑할 모델 설정
     * @param param : Alamofire Request 파라미터 설정
     * @Return : 성공 -> 매핑된 데이터 클로저 반환, 실패 -> 에러타입 반환
     */
    public func requestData<T: Decodable>(type: T.Type, param: NetworkParameters, complete: @escaping (ApiResult<T>) -> Void) {
        AF.request(param.url
                  , method: param.method
                  , parameters: param.parameter
                  , headers: param.header).responseData { response in
            
            switch response.result {
            case let .success(data):
                if let json = try? JSONDecoder().decode(type, from: data) {
                    complete(.success(json))
                    return
                }
                complete(.failure(ApiError.encodingError))
            case let .failure(error):
                print("Alamofire Error --------------------> \(error)")
                complete(.failure(ApiError.statusCodeError))
            }
        }
    }
    
    /**
     * @이미지 데이터를 요청합니다.
     * @creator : coder3306
     * @param url : 이미지 다운로드 주소
     * @Return : 다운로드된 이미지 반환
     */
    public func downloadImage(url: String, complete: @escaping (UIImage?) -> ()) {
        AF.request(url, method: .get, parameters: nil, interceptor: nil).validate().responseData { response in
            switch response.result {
                case let .success(data):
                    if let image = UIImage(data: data) {
                        complete(image)
                        return
                    }
                    complete(nil)
                case let .failure(error):
                    complete(nil)
                    print(error)
            }
        }
    }
}
