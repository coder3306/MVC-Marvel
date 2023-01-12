//
//  MarvelCharactersDetailTask.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/12.
//

import Foundation

protocol MarvelCharactersDetailTaskInput {
    func requestComicsList(_ limit: Int)
    func requestEventList(_ limit: Int)
    func requestSeriesList(_ limit: Int)
}

protocol MarvelCharactersDetailTaskOutput: AnyObject {
    
}

final class MarvelCharactersDetailTask: MarvelCharactersDetailTaskInput {
    weak var output: MarvelCharactersDetailTaskOutput?
    
    func requestComicsList(_ limit: Int) {
        print(limit)
    }
    
    func requestEventList(_ limit: Int) {
        print(limit)
    }
    
    func requestSeriesList(_ limit: Int) {
        print(limit)
    }
}
