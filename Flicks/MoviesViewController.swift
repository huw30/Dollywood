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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!

    var movies: [[String: Any]] = [[String: Any]]()
    var alertView: AlertViewController!
    var refreshControl: UIRefreshControl!
    var filtered:[[String: Any]] = [[String: Any]]()
    var searchActive : Bool = false
    var searchNoResult: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        clearErrorMessage()
        setStyle()
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        movieSearchBar.delegate = self

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        fetchMovies()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie: [String: Any]

        if(searchActive){
            movie = filtered[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }

        cell.initCell(with: movie)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if (searchActive && filtered.count == 0) {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No result found"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        } else {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        return numOfSections
    }
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }

    func fetchMovies() {
        let tabBarIndex = self.tabBarController?.selectedIndex
        let url: URL!

        if (tabBarIndex == 0) {
            url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        } else {
            url = URL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in

            if let error = error {
                Util.handleError(error: error, controller: self)
            } else {
                if let data = dataOrNil {
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                    self.movies = dictionary["results"] as! [[String: Any]]

                    self.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.refreshControl.endRefreshing()
                }
            }
        })

        task.resume()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = searchText.isEmpty ? movies : movies.filter({ (movie) -> Bool in
            let movieTitle = movie["title"] as! String
            let movieOverview = movie["overview"] as! String
            let titleRange = movieTitle.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            let overviewRange = movieOverview.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            return titleRange || overviewRange
        })
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MovieDetailsViewController
        let currentCell = sender as! MovieCell
        
        destination.movie = currentCell.movie
        destination.posterImage = currentCell.posterView.image
    }

    func clearErrorMessage() {
        if let alertView = alertView {
            alertView.dissmissMessage(self)
        }
    }
    func setStyle() {
        // Styling nav bar
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = Constants.Colors.bgColor
            navigationBar.tintColor = Constants.Colors.lightGrey
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors.orange]
        }

        self.tableView.backgroundColor = Constants.Colors.bgColor
    }
}

