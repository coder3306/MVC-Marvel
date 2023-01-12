//
//  ViewController.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/09.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func actionMoveCharacters(_ sender: UIButton) {
        let characters = MarvelCharactersListViewController(nibName: "MarvelCharactersListViewController", bundle: nil)
        self.navigationController?.pushViewController(characters, animated: true)
    }
}

