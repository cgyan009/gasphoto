//
//  SceneDelegate.swift
//  GasPhoto
//
//  Created by Chenguo Yan on 2020-02-26.
//  Copyright © 2020 Chenguo Yan. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationViewController = UINavigationController()
        window?.rootViewController = navigationViewController
        navigationViewController.pushViewController(HomeViewController(), animated: true)
        window?.makeKeyAndVisible()
    }
}

