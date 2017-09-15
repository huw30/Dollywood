//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Raina Wang on 9/13/17.
//  Copyright © 2017 Raina Wang. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailsViewController: UIViewController {

    var movie: [String: Any]!
    var posterImage: UIImage!

    @IBOutlet weak var backDropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var generalInfoView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    
    @IBOutlet weak var movieOverview: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setComponentInfo()
    }
    
    func setComponentInfo() {
        var backDropURL: URL!
        
        if let backDrop = movie["backdrop_path"] as? String {
            let baseURL = "http://image.tmdb.org/t/p/w500"
            backDropURL = URL(string: baseURL + backDrop)
            backDropView.setImageWith(backDropURL)
        } else {
            backDropView.image = posterImage
        }

        let title = movie["title"] as? String
        let synopsis = movie["overview"] as? String

        posterView.image = posterImage
        movieTitle.text = title
        movieOverview.text = synopsis
    }

}
