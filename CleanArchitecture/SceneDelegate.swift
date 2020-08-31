//
//  SceneDelegate.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/21.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    static var window: UIWindow?
    static var tabBar: UITabBarController!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            SceneDelegate.window = UIWindow(windowScene: windowScene)

            // Home(search music) tab
            let home = MusicContainer.shared.resolve(HomeViewController.self)!
            home.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "homeY"), tag: 0)
            let homeNaviVC = UINavigationController(rootViewController: home)

            // Favorites tab
            let favorite = MusicContainer.shared.resolve(FavoriteViewController.self)!
            favorite.tabBarItem = UITabBarItem(title: "보관함", image: UIImage(named: "bookmarkY"), tag: 1)
            let favNaviVC = UINavigationController(rootViewController: favorite)

            // Configure tab bar and main window
            let tabBar = UITabBarController()
            tabBar.viewControllers = [homeNaviVC, favNaviVC]
            tabBar.tabBar.tintColor = UIColor(hex: 0xf88379)
            tabBar.tabBar.barTintColor = .white
            SceneDelegate.tabBar = tabBar
            SceneDelegate.window?.rootViewController = tabBar
            SceneDelegate.window?.makeKeyAndVisible()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

}
