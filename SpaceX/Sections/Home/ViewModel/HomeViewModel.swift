//
//  HomeViewModel.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import Foundation

protocol HomeViewModelProtocol {
    var viewDelegate: HomeViewModelViewDelegate? { get set }
    
    func viewDidLoad()
    func fetchInfo()
    func fetchLaunches()
    func openDetails(index: Int)
    func getLaunchesSize() -> Int
    func getLaunche(for index: Int) -> LaunchesModel
}

protocol HomeViewModelCoordinatorDelegate: AnyObject {
    func openDetails(viewModel: HomeViewModel, model: LaunchesModel)
}

protocol HomeViewModelViewDelegate: AnyObject {
    func loadedInfoData(viewModel: HomeViewModel, infoText: String)
    func loadedLaunchedData(viewModel: HomeViewModel)
    func loadedWithFailure(viewModel: HomeViewModel, networkError: NetworkError)
}

class HomeViewModel: HomeViewModelProtocol {
    weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
    weak var viewDelegate: HomeViewModelViewDelegate?
    
    private var launchesModel: [LaunchesModel] = []
    private let service: NetworkService<HomeAPI>
    
    init(service: NetworkService<HomeAPI> = NetworkService<HomeAPI>()) {
        self.service = service
    }
    
    func viewDidLoad() {
        fetchInfo()
        fetchLaunches()
    }
    
    func fetchInfo() {
        service.request(target: .info, expecting: InfoModel.self) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.viewDelegate?.loadedInfoData(viewModel: self, infoText: self.generateInfoText(for: model))
            case .failure(let error):
                self.viewDelegate?.loadedWithFailure(viewModel: self, networkError: error)
            }
        }
    }
    
    func fetchLaunches() {
        service.request(target: .launches, expecting: [LaunchesModel].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.launchesModel.append(contentsOf: model)
                self.viewDelegate?.loadedLaunchedData(viewModel: self)
            case .failure(let error):
                self.viewDelegate?.loadedWithFailure(viewModel: self, networkError: error)
            }
        }
    }
    
    func getLaunchesSize() -> Int {
        return launchesModel.count
    }
    
    func getLaunche(for index: Int) -> LaunchesModel {
        return launchesModel[index]
    }
    
    private func generateInfoText(for model: InfoModel) -> String {
        let convertedValuation = getConvertedValuation(value: model.valuation)
        
        return "\(model.name) was founded by \(model.founder) in \(model.year). It has now \(model.employees) employees, " +
            "\(model.launchSites) launch sites, and is valued at USD \(convertedValuation)."
    }
    
    private func getConvertedValuation(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currencyAccounting
        formatter.locale = Locale(identifier: "US")
        formatter.currencyCode = "usd"
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
    func openDetails(index: Int) {
        coordinatorDelegate?.openDetails(viewModel: self, model: launchesModel[index])
    }
}
