//
//  HomeViewController.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: HomeViewModelProtocol
        
    required init?(coder aDecoder: NSCoder) {
        viewModel = HomeViewModel()
        super.init(coder: aDecoder)
    }
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.viewDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SpaceX"
        setupTableView()
        viewModel.viewDidLoad()
    }
}

extension HomeViewController: HomeViewModelViewDelegate {
    func loadedInfoData(viewModel: HomeViewModel, infoText: String) {
        DispatchQueue.main.async {
            self.companyLabel.text = infoText
        }
    }
    
    func loadedLaunchedData(viewModel: HomeViewModel) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
        }
    }
    
    func loadedWithFailure(viewModel: HomeViewModel, networkError: NetworkError) {
        print("--------------")
        print("Request failed")
        print(networkError)
        print("--------------")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let homeCell = UINib(nibName: LaunchesCell.identifier, bundle: nil)
        tableView.register(homeCell, forCellReuseIdentifier: LaunchesCell.identifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getLaunchesSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LaunchesCell.identifier) as? LaunchesCell {
            let model = viewModel.getLaunche(for: indexPath.row)
            cell.setup(model: model)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.openDetails(index: indexPath.row)
    }
}
