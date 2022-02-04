//
//  HomeTableViewCell.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import UIKit
import Kingfisher

class LaunchesCell: UITableViewCell {
    static var identifier = "LaunchesCell"
    
    @IBOutlet weak var rocketImage: UIImageView!
    @IBOutlet weak var missionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rocketLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        rocketImage.image = nil
    }
    
    func setup(model: LaunchesModel) {
        setupImage(url: model.links.smallImageUrl)
        indicatorView.startAnimating()
        missionLabel.text = model.missionName
        rocketLabel.text = "\(model.rocket.rocketName) / \(model.rocket.rocketType)"
        setupTime(timeInterval: TimeInterval(model.launchDate))
        setupDays(timeInterval: TimeInterval(model.launchDate))
        statusImage.image = UIImage(named: getImageNameForStatus(status: model.launchSuccess ?? false))
    }
    
    func setupImage(url: URL?) {
        if let url = url {
            rocketImage?.kf.setImage(with: KingfisherResource(cacheKey: url.absoluteString, downloadURL: url))
        }
    }
    
    private func getImageNameForStatus(status: Bool) -> String {
        status ? "success-icon" : "error-icon"
    }
    
    private func setupRocketImage(image: UIImage) {
        indicatorView.isHidden = true
        rocketImage.image = image
    }
    
    private func setupDays(timeInterval: TimeInterval) {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.maximumUnitCount = 2
        dateFormatter.unitsStyle = .full
        dateFormatter.allowedUnits = [.day]
        let days = dateFormatter.string(from: date, to: Date())
        
        daysLabel.text = days
    }
    
    private func setupTime(timeInterval: TimeInterval) {
        let date = Date(timeIntervalSince1970: timeInterval)
        dateLabel.text = date.toStringWithFormat(.fullDate)
    }
}
