//
//  HomeCoordinator.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import UIKit

class HomeCoordinator: Coordinator {
    weak var delegate: CoordinatorDelegate?
    var childCoordinator: Coordinator?
    var viewController: UIViewController
    var navigationController: UINavigationController?
    
    init() {
        let viewModel = HomeViewModel()
        viewController = HomeViewController(viewModel: viewModel)
        viewModel.coordinatorDelegate = self
    }
}

extension HomeCoordinator: HomeViewModelCoordinatorDelegate {
    func openDetails(viewModel: HomeViewModel, model: LaunchesModel) {
        guard let navigationController = navigationController else { return }
        let flightDetailsCoordinator = FlightDetailsCoordinator(model: model)
        route(to: flightDetailsCoordinator, withPresenter: .push(navigationController))
    }
}
