//
//  DetailsViewController.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 17/01/22.
//

import UIKit
import Kingfisher

class FlightDetailsViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    private let viewModel: FlightDetailsViewModelProtocol

    required init?(coder aDecoder: NSCoder) {
        viewModel = FlightDetailsViewModel(links: .init(articleLink: nil,
                                                        videoLink: nil,
                                                        wikipediaLink: nil,
                                                        smallImage: nil,
                                                        largeImage: nil))
        super.init(coder: aDecoder)
    }
    
    init(viewModel: FlightDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
    func loadImage() {
        if let urlString = viewModel.imageUrl, let url = URL(string: urlString) {
            imageView.kf.setImage(with: KingfisherResource(cacheKey: urlString, downloadURL: url))
        }
    }
    
    @IBAction func articleButton(_ sender: Any) {
        openUrl(viewModel.getUrl(for: .article))
    }
    
    @IBAction func wikipediaButton(_ sender: Any) {
        openUrl(viewModel.getUrl(for: .wikipedia))
    }
    
    @IBAction func videoButton(_ sender: Any) {
        openUrl(viewModel.getUrl(for: .video))
    }
    
    private func openUrl(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            print("Can't open this URL: \(url)")
            return
        }
        UIApplication.shared.open(url)
    }
}
