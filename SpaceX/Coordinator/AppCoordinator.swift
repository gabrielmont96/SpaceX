//
//  AppCoordinator.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import UIKit

class AppCoordinator {
    let window: UIWindow
    var homeCoordinator: HomeCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let coordinator = HomeCoordinator()
        homeCoordinator = coordinator
        let navigation = UINavigationController(rootViewController: coordinator.viewController)
        coordinator.navigationController = navigation
        window.rootViewController = navigation
    }
}
