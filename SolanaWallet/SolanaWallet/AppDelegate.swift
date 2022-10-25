//
//  AppDelegate.swift
//  SolanaWallet
//
//  Created by Anton Makarenkov on 25.10.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIBuilder.buildTabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

enum UIBuilder {
    static func buildTabBarController() -> UIViewController {
        
        let tabBarController = UITabBarController()
        let receiveViewController = ReceiveViewController()
        receiveViewController.tabBarItem = UITabBarItem()
        receiveViewController.tabBarItem.title = "Recieve"
        receiveViewController.tabBarItem.image = UIImage(systemName: "arrow.down.forward.and.arrow.up.backward")
        
        let sendViewController = SendViewController()
        sendViewController.tabBarItem = UITabBarItem()
        sendViewController.tabBarItem.title = "Send"
        sendViewController.tabBarItem.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
        let viewControllers = [receiveViewController, sendViewController]
        tabBarController.setViewControllers(viewControllers, animated: false)
        return tabBarController
    }
}

