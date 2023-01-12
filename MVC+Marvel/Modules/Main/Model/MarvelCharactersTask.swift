//
//  MarvelCharactersTask.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation

protocol MarvelCharactersTaskInput {
    func requestCharactersList(for limit: Int, complete: @escaping () -> ())
}

protocol MarvelCharactersTaskOutput: AnyObject {
    func responseCharactersList(with characters: Characters?)
}

final class MarvelCharactersTask: MarvelCharactersTaskInput {
    
    weak var output: MarvelCharactersTaskOutput?
    
    func requestCharactersList(for limit: Int, complete: @escaping () -> ()) {
        var parameter = NetworkParameters(url: "", method: .get)
        guard let requestMarvelInfo = parameter.getMarvelData(limit) else { return }
        DispatchQueue.main.async {
            NetworkManager.shared.requestData(type: Characters.self, param: requestMarvelInfo) { [weak self] response in
                switch response {
                    case .success(let t):
                        self?.output?.responseCharactersList(with: t)
                        complete()
                    case .failure(let apiError):
                        print("API ERROR --------------- >>>>>>> \(apiError)")
                        self?.output?.responseCharactersList(with: nil)
                }
            }
        }
        print("RequestItem")
    }
}
