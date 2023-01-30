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
     * @param limit : 한번에 요청할 데이터 갯수
     */
    func requestCharactersList(for limit: Int)
}

protocol MarvelCharactersTaskOutput: AnyObject {
    /**
     * @다운로드된 캐릭터 리스트
     * @creator : coder3306
     */
    func responseCharactersList(with characters: Marvel?)
}

final class MarvelCharactersTask: MarvelCharactersTaskInput {
    
    weak var output: MarvelCharactersTaskOutput?
    private let url = "http://gateway.marvel.com/v1/public/characters"
    
    func requestCharactersList(for limit: Int) {
        var parameter = NetworkParameters(url: url, method: .get)
        guard let requestMarvelInfo = parameter.getMarvelData(limit) else { return }
        DispatchQueue.main.async {
            NetworkManager.shared.requestData(type: Marvel.self, param: requestMarvelInfo) { [weak self] response in
                switch response {
                    case .success(let character):
                        self?.output?.responseCharactersList(with: character)
                    case .failure(let apiError):
                        print("API ERROR --------------- >>>>>>> \(apiError)")
                        self?.output?.responseCharactersList(with: nil)
                }
            }
        }
        print("RequestItem")
    }
}
