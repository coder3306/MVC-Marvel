//
//  MarvelCharacterDetailViewController.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/12.
//

import UIKit

class MarvelCharacterDetailViewController: CommonViewController {
    var items: Comics?
    var model: MarvelCharactersDetailTaskInput?
    private var tableConfig = CommonConfig<MarvelDetail>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let url = items?.collectionURI {
            self.model?.requestDetailList(type: MarvelDetail.self, url: url, limit: items?.available ?? 0)
        }
    }
    
    private func bindModel() {
        let model = MarvelCharactersDetailTask()
        model.output = self
        self.model = model
    }
    
    private func downloadDetailList(info: CharactersInfo) {
//        let url = items?.collectionURI ?? ""
    }
}

//MARK: - Output
extension MarvelCharacterDetailViewController: MarvelCharactersDetailTaskOutput {
    func responseDetailList<T>(_ item: T) {
        print(item)
    }
}
