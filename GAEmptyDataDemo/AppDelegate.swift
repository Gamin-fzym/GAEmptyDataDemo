//
//  AppDelegate.swift
//  GAEmptyDataDemo
//
//  Created by MaciOS on 2021/10/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = GAHomeVC(nibName: "GAHomeVC", bundle: nil)
        window?.makeKeyAndVisible()
        
        NetstatManager.shared.NetworkStatusListener()

        return true
    }

}

