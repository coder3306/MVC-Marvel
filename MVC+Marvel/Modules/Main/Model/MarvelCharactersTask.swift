//
//  MarvelCharactersTask.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation

protocol MarvelCharactersTaskInput {
    /**
     * @캐릭터 리스트 요청
     * @creator : coder3306
     * @param type : 모델 데이터
     * @param limit : 한번에 요청할 데이터 갯수
     */
    func requestCharactersList<T: Decodable>(type: T.Type, for limit: Int)
}

protocol MarvelCharactersTaskOutput: AnyObject {
    /**
     * @캐릭터 리스트 응답 데이터
     * @creator : coder3306
     * @param characters : 리스트 모델 데이터
     */
    func responseCharactersList(_ characters: Marvel?)
}

final class MarvelCharactersTask: MarvelCharactersTaskInput {
    /// 응답 데이터 델리게이트 프로토콜 설정
    weak var output: MarvelCharactersTaskOutput?
    /// 요청 url 주소
    private let url: MarvelURL
    /// 네트워크 설정
    private let networkClient: NetworkClient
    
    /**
     * @비즈니스 로직 초기화
     * @creator : coder3306
     * @param networkClient : 네트워크 설정 프로토콜
     * @param url : 요청 URL 주소
     */
    init(networkClient: NetworkClient, url: MarvelURL) {
        self.networkClient = networkClient
        self.url = url
    }
    
    /**
     * @캐릭터 리스트 요청
     * @creator : coder3306
     * @param type : 모델 데이터
     * @param limit : 한번에 호출할 데이터 갯수 설정
     * @Return : Output으로 매핑 처리된 데이터 전달
     */
    func requestCharactersList<T: Decodable>(type: T.Type, for limit: Int) {
        var parameter = NetworkParameters(url: url.resource, method: .get)
        guard let requestMarvelInfo = parameter.getMarvelData(limit) else { return }

        networkClient.requestData(param: requestMarvelInfo) { [weak self] result in
            switch result {
                case .success(let data):
                    do {
                        let parsing = try JSONDecoder().decode(type, from: data)
                        self?.output?.responseCharactersList(parsing as? Marvel)
                    } catch {
                        self?.output?.responseCharactersList(nil)
                        print("JSON Decoding error ------------ >>> \(error)")
                    }
                case .failure(let apiError):
                    self?.output?.responseCharactersList(nil)
                    print("Api Call error ------------ >>> \(apiError)")
            }
        }
    }
}
