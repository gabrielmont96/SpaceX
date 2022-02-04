//
//  DetailsCoordinator.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 17/01/22.
//

import UIKit

class FlightDetailsCoordinator: Coordinator {
    weak var delegate: CoordinatorDelegate?
    var childCoordinator: Coordinator?
    var viewController: UIViewController
    var navigationController: UINavigationController?
    
    init(model: LaunchesModel) {
        let viewModel = FlightDetailsViewModel(links: model.links)
        viewController = FlightDetailsViewController(viewModel: viewModel)
    }
}
