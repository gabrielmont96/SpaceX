//
//  AppDelegate.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 25/01/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.makeKeyAndVisible()
        self.window = window
        
        appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        return true
    }
}

