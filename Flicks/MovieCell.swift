//
//  MovieCell.swift
//  Flicks
//
//  Created by Raina Wang on 9/12/17.
//  Copyright © 2017 Raina Wang. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    var movie: [String: Any]!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var releaseDateLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func initCell(with movie: [String: Any]) {
        let title = movie["title"] as? String
        let synopsis = movie["overview"] as? String
        let score = movie["vote_average"] as? Double
        let releaseDate = movie["release_date"] as? String
        
        if let path = movie["poster_path"] as? String {
            let lowResURL = URL(string: Constants.URLs.smallPosterBaseUrl + path)
            let highResURL = URL(string: Constants.URLs.originalPosterBaseUrl + path)
            Util.loadImageFromLowToHigh(imgView: self.posterView, lowResURL: lowResURL!, highResURL: highResURL!)
        }
        
        self.titleLabel.text = title
        self.synopsisLabel.text = synopsis
        self.movie = movie
        self.backgroundColor = UIColor.clear

        if score != nil {
            self.scoreLabel.text = String(format:"%.1f", score!)
        }

        self.scoreLabel.layer.masksToBounds = true
        self.scoreLabel.layer.cornerRadius = 5
        
        if releaseDate != nil {
            self.releaseDateLable.text = releaseDate
        }

        self.synopsisLabel.sizeToFit()
    }

}
