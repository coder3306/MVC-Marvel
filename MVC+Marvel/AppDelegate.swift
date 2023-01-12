//
//  AppDelegate.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/09.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootNavigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setMain()
        return true
    }
    
    private func setMain() {
        let main = MarvelCharactersListViewController(nibName: "MarvelCharactersListViewController", bundle: nil)
        rootNavigationController = UINavigationController(rootViewController: main)
        self.window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
}

