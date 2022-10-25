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
        window?.rootViewController = TransactionViewController()
        window?.makeKeyAndVisible()
        
        return true
    }


}

