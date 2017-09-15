//
//  ViewController.swift
//  Flicks
//
//  Created by Raina Wang on 9/12/17.
//  Copyright © 2017 Raina Wang. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var movies: [[String: Any]] = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        fetchMovies()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell

        let movie = movies[indexPath.row]
        let title = movie["title"] as? String
        let synopsis = movie["overview"] as? String
        var posterURL: URL!

        if let path = movie["poster_path"] as? String {
            let baseURL = "http://image.tmdb.org/t/p/w500"
            posterURL = URL(string: baseURL + path)
        }

        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        cell.posterView.setImageWith(posterURL)
        cell.movie = movie

        return cell
    }

    func fetchMovies() {
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in

            if let error = error {
                self.handleError(error: error)
            } else {
                if let data = dataOrNil {
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                    self.movies = dictionary["results"] as! [[String: Any]]
                    self.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        });
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MovieDetailsViewController
        let currentCell = sender as! MovieCell
        
        destination.movie = currentCell.movie
        destination.posterImage = currentCell.posterView.image
    }

    func handleError(error: Error) {
        
    }
}

