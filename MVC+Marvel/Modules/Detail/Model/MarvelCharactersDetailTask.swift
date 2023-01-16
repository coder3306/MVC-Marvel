//
//  MarvelCharactersDetailTask.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/12.
//

import Foundation

protocol MarvelCharactersDetailTaskInput {
    func requestDetailList<T: Decodable>(type: T.Type, url: String, limit: Int)
}

protocol MarvelCharactersDetailTaskOutput: AnyObject {
    func responseDetailList(_ item: MarvelDetail?)
}

final class MarvelCharactersDetailTask: MarvelCharactersDetailTaskInput {
    weak var output: MarvelCharactersDetailTaskOutput?
    
    /**
     * @네트워크 파라미터 초기화
     * @creator : coder3306
     * @param url : 호출할 URL 주소
     * @param limit : 한번에 호출할 데이터 갯수 설정
     * @Return : 설정된 파라미터 반환
     */
    private func initNetworkParameter(url: String, limit: Int) -> NetworkParameters? {
        var parameter = NetworkParameters(url: url, method: .get)
        return parameter.getMarvelData(limit)
    }
    
    /**
     * @캐릭터 상세보기 이벤트 데이터 호출
     * @creator : coder3306
     * @param type : 모델 데이터
     * @param url : 호출할 URL 설정
     * @param limit : 한번에 호출할 데이터 갯수 설정
     * @Return : Output으로 데이터 전달
     */
    func requestDetailList<T: Decodable>(type: T.Type, url: String, limit: Int) {
        guard let param = initNetworkParameter(url: url, limit: limit) else { return }
        NetworkManager.shared.requestData(type: type, param: param) { result in
            switch result {
                case .success(let t):
                    if let detail = t as? MarvelDetail {
                        self.output?.responseDetailList(detail)
                    } else {
                        self.output?.responseDetailList(nil)
                    }
                case .failure(let apiError):
                    print("Api Call error ------------ >>> \(apiError)")
                    self.output?.responseDetailList(nil)
            }
        }
    }
}
