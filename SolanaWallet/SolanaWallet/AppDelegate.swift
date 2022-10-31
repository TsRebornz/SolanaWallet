//
//  AppDelegate.swift
//  SolanaWallet
//
//  Created by Anton Makarenkov on 25.10.22.
//

import UIKit
import TweetNacl

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = Builder.buildTabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

enum Builder {
    static func buildTabBarController() -> UIViewController {
        
        let tabBarController = UITabBarController()
        
        let receiveViewController = Self.buildReceiveViewController()
        receiveViewController.tabBarItem = UITabBarItem()
        receiveViewController.tabBarItem.title = "Recieve"
        receiveViewController.tabBarItem.image = UIImage(systemName: "arrow.down.forward.and.arrow.up.backward")
        
        let sendViewController = Self.buildSendViewController()
        sendViewController.tabBarItem = UITabBarItem()
        sendViewController.tabBarItem.title = "Send"
        sendViewController.tabBarItem.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
        let viewControllers = [receiveViewController, sendViewController]
        tabBarController.setViewControllers(viewControllers, animated: false)
        return tabBarController
    }
    
    static func buildReceiveViewController() -> ReceiveViewController {
        let currentUserData = UserData.current
        let networkManager = buildNetworkManager()
        let viewModel = ReceiveViewModel(networkManager: networkManager, state: currentUserData)
        let receiveViewController = ReceiveViewController(viewModel: viewModel)
        return receiveViewController
    }
    
    static func buildSendViewController() -> SendViewController {
        let networkManager = buildNetworkManager()
        let blockChainClient = BlockchainClient(apiClient: networkManager)
        let userData = UserData.current
        let sendViewModel = SendViewModel(client: blockChainClient, state: userData)
        let sendViewController = SendViewController(viewModel: sendViewModel)
        return sendViewController
    }
    
    static func buildNetworkManager() -> NetworkManager {
        let urlSession = buildURLSession()
        let baseNetowork = BaseNetworkManager(networkSession: urlSession)
        return NetworkManager(network: baseNetowork)
    }
    
    static func buildURLSession() -> URLSession {
        return URLSession.shared
    }
}

