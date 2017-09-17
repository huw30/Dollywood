//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Raina Wang on 9/13/17.
//  Copyright © 2017 Raina Wang. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieDetailsViewController: UIViewController {

    var movie: [String: Any]!
    var movieDetails: [String: Any]!
    var posterImage: UIImage!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backDropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var generalInfoView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    
    @IBOutlet weak var movieOverview: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let movieId = movie["id"] as? Int
        fetchMovieDetail(with: movieId!)

        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
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
        let tagline = movieDetails["tagline"] as? String
        let score = movie["vote_average"] as? Double
        let genres = getGenres()
        let runtime = getRuntime()

        posterView.image = posterImage
        movieTitle.text = title
        movieOverview.text = synopsis
        movieOverview.sizeToFit()
        taglineLabel.text = tagline
        genreLabel.text = genres
        runtimeLabel.text = runtime
        genreLabel.sizeToFit()

        self.title = title

        if score != nil {
            self.scoreLabel.text = String(format:"%.1f", score!)
        }

        self.scoreLabel.layer.masksToBounds = true
        self.scoreLabel.layer.cornerRadius = 5
    }

    func fetchMovieDetail(with movieId: Int) {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")

        var request = URLRequest(url: url!)

        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )

        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                let movie = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.movieDetails = movie
                MBProgressHUD.hide(for: self.view, animated: true)
                self.setComponentInfo()
            }
        })
        task.resume()

    }

    func getGenres() -> String {
        var res: String = ""
        let genres = movieDetails["genres"]
        for dataObject in genres as! NSArray
        {
            if let data = dataObject as? NSDictionary
            {
                // Do stuff with data
                res.append(data.allValues[1] as! String + ", ")
            }
        }

        res.remove(at: res.index(before: res.endIndex))

        return res.substring(to: res.index(before: res.endIndex))
    }

    func getRuntime() -> String {
        if let runtime = movieDetails["runtime"] {
            let (h,m) = Util.minsToHoursMinutes(mins: runtime as! Int)
            return "\(h) h, \(m) mins"
        }
        return ""
    }
}
