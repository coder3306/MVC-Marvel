//
//  MarvelCharactersDetailTask.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/12.
//

import Foundation

protocol MarvelCharactersDetailTaskInput {
    /**
     * @캐릭터 상세보기 데이터 요청
     * @creator : coder3306
     * @param type : 모델 데이터
     * @param limit : 한번에 요청할 데이터 갯수
     */
    func requestDetailList<T: Decodable>(type: T.Type, url: String, for limit: Int)
}

protocol MarvelCharactersDetailTaskOutput: AnyObject {
    /**
     * @캐릭터 상세보기 응답 데이터
     * @creator : coder3306
     * @param item : 상세보기 모델 데이터
     */
    func responseDetailList(_ item: MarvelDetail?)
}

//MARK: Business Logic
final class MarvelCharactersDetailTask: MarvelCharactersDetailTaskInput {
    // 네트워크 설정
    private let networkClient : NetworkClient
    // 데이터 전달 프로토콜 델리게이트 설정
    weak var output: MarvelCharactersDetailTaskOutput?
    
    /**
     * @비즈니스 로직 초기화
     * @creator : coder3306
     * @param networkClient : 네트워크 설정 프로토콜
     */
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    /**
     * @캐릭터 상세보기 이벤트 데이터 요청
     * @creator : coder3306
     * @param type : 모델 데이터
     * @param url : 호출할 URL 설정
     * @param limit : 한번에 호출할 데이터 갯수 설정
     * @Return : Output으로 데이터 전달
     */
    
    func requestDetailList<T: Decodable>(type: T.Type, url: String, for limit: Int) {
        var parameter = NetworkParameters(url: url, method: .get)
        guard let requestMarvelInfo = parameter.getMarvelData(limit) else { return }

        networkClient.requestData(param: requestMarvelInfo) { [weak self] result in
            switch result {
                case .success(let data):
                    do {
                        let parsing = try JSONDecoder().decode(type, from: data)
                        self?.output?.responseDetailList(parsing as? MarvelDetail)
                    } catch {
                        self?.output?.responseDetailList(nil)
                        print("JSON Decoding error ------------ >>> \(error)")
                    }
                case .failure(let apiError):
                    self?.output?.responseDetailList(nil)
                    print("Api Call error ------------ >>> \(apiError)")
            }
        }
    }
}
