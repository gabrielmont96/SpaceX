//
//  Coordinator.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    func didFinishWithSuccess(_ coordinator: Coordinator, data: Data?)
    func didFinishWithError(_ coordinator: Coordinator)
}

extension CoordinatorDelegate {
    func didFinishWithSuccess(_ coordinator: Coordinator, data: Data?) { }
    func didFinishWithError(_ coordinator: Coordinator) { }
}

protocol Coordinator: CoordinatorDelegate {
    var delegate: CoordinatorDelegate? { get set }
    var childCoordinator: Coordinator? { get set }
    var viewController: UIViewController { get set }
    var navigationController: UINavigationController? { get set }
    
    func stop()
    func start(usingPresenter presenter: CoordinatorPresenter, animated: Bool)
    func route(to coordinator: Coordinator, withPresenter presenter: CoordinatorPresenter, animated: Bool, delegate: CoordinatorDelegate?)
    func performStart(usingPresenter presenter: CoordinatorPresenter, animated: Bool)
}

extension Coordinator {
    func route(to coordinator: Coordinator,
               withPresenter presenter: CoordinatorPresenter,
               animated: Bool = true,
               delegate: CoordinatorDelegate? = nil) {
        childCoordinator = coordinator
        coordinator.delegate = delegate ?? self
        coordinator.start(usingPresenter: presenter, animated: animated)
    }
    
    func start(usingPresenter presenter: CoordinatorPresenter, animated: Bool = true) {
        performStart(usingPresenter: presenter, animated: animated)
    }

    func stop() {
        delegate = nil
        childCoordinator = nil
        navigationController = nil
    }
    
    func performStart(usingPresenter presenter: CoordinatorPresenter, animated: Bool) {
        navigationController = presenter.present(destiny: viewController, animated: animated)
    }
}

protocol CoordinatorPresenterProtocol {
    var rootViewController: UIViewController { get }
    func present(destiny destinyViewController: UIViewController, animated: Bool) -> UINavigationController
}

enum CoordinatorPresenter: CoordinatorPresenterProtocol {
    case push(UINavigationController)
    case present(UIViewController, UIModalPresentationStyle = .fullScreen)
}

extension CoordinatorPresenter {
    var rootViewController: UIViewController {
        switch self {
        case .push(let navigationController): return navigationController
        case .present(let viewController, _): return viewController
        }
    }
    
    func present(destiny destinyViewController: UIViewController, animated: Bool) -> UINavigationController {
        switch self {
        case .push(let navigationController):
            return pushStart(navigationController: navigationController, destiny: destinyViewController, animated: animated)
        case .present(let viewController, let style):
            return presentStart(viewController: viewController, style: style, destiny: destinyViewController, animated: animated)
        }
    }
}

private extension CoordinatorPresenter {
    func pushStart(navigationController: UINavigationController,
                   destiny destinyViewController: UIViewController,
                   animated: Bool) -> UINavigationController {
        navigationController.pushViewController(destinyViewController, animated: animated)
        return navigationController
    }
    
    func presentStart(viewController: UIViewController,
                      style: UIModalPresentationStyle,
                      destiny destinyViewController: UIViewController,
                      animated: Bool) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: destinyViewController)
        navigationController.modalPresentationStyle = style
        viewController.present(navigationController, animated: animated, completion: nil)
        return navigationController
    }
}
