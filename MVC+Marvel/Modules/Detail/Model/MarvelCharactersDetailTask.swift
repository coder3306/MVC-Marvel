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
    func responseDetailList<T>(_ item: T)
}

final class MarvelCharactersDetailTask: MarvelCharactersDetailTaskInput {
    weak var output: MarvelCharactersDetailTaskOutput?
    
    private func initNetworkParameter(url: String, limit: Int) -> NetworkParameters? {
        var parameter = NetworkParameters(url: url, method: .get)
        guard let inputParam = parameter.getMarvelData(limit) else { return nil }
        return inputParam
    }
    
    func requestDetailList<T: Decodable>(type: T.Type, url: String, limit: Int) {
        guard let param = initNetworkParameter(url: url, limit: limit) else { return }
        NetworkManager.shared.requestData(type: type, param: param) { result in
            switch result {
                case .success(let t):
                    self.output?.responseDetailList(t)
                case .failure(let apiError):
                    print("Api Call error ------------ >>> \(apiError)")
            }
        }
    }
}
