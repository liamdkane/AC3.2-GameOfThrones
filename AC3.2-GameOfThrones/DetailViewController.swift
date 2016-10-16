//
//  DetailViewController.swift
//  AC3.2-GameOfThrones
//
//  Created by C4Q on 10/13/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var episode: GOTEpisode?
    
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentEpisode = episode {
            title = currentEpisode.name
            airDateLabel.text = "Aired on: \(currentEpisode.airdate)"
            summaryLabel.text = currentEpisode.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            numberLabel.text = "Season: \(String(currentEpisode.season)), Episode Number: \(String(currentEpisode.number))"
            if let url = URL.init(string: currentEpisode.image), let data = try? Data(contentsOf: url), let imageOfEpisode = UIImage.init(data: data) {
                image.image = imageOfEpisode
            }
        }
    }
    
}
