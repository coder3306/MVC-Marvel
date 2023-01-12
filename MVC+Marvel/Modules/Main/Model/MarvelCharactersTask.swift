//
//  MarvelCharactersTask.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation

protocol MarvelCharactersTaskInput {
    func requestCharactersList(for limit: Int)
//    func requestImageDownload(url: URL)
}

protocol MarvelCharactersTaskOutput: AnyObject {
    func responseCharactersList(with characters: Characters?)
//    func responseImage(image: [String: Any]?)
}

final class MarvelCharactersTask: MarvelCharactersTaskInput {
    
    weak var output: MarvelCharactersTaskOutput?
    
    func requestCharactersList(for limit: Int) {
        var parameter = NetworkParameters(url: "", method: .get)
        guard let requestMarvelInfo = parameter.getMarvelData(limit) else { return }
        DispatchQueue.main.async {
            NetworkManager.shared.requestData(type: Characters.self, param: requestMarvelInfo) { [weak self] response in
                switch response {
                    case .success(let t):
                        self?.output?.responseCharactersList(with: t)
                    case .failure(let apiError):
                        print("API ERROR --------------- >>>>>>> \(apiError)")
                        self?.output?.responseCharactersList(with: nil)
                }
            }
        }
        print("RequestItem")
    }
    
//    func requestImageDownload(url: URL) {
//        DispatchQueue.global().async {
//            NetworkManager.shared.downloadImage(url: url) { [weak self] image in
//                var result = [String: Any]()
//                result["\(url)"] = image
//                self?.output?.responseImage(image: result)
//            }
//        }
//    }
}
