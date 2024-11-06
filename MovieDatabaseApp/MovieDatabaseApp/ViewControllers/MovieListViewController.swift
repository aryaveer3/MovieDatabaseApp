//
//  MovieListViewController.swift
//  MovieDatabaseApp
//
//  Created by Aryaveer Bajpai on 05/11/24.
//

import Foundation
import UIKit
import Kingfisher

class MovieListViewController: UIViewController{
    
    var movies:[MovieElement] = MovieService.loadMovies()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        setupTableView()
    }
    
    
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    

    private func setupTableView() {
        // Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register the custom cell NIB
        let nib = UINib(nibName: "MovieDetailCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MovieDetailCell")
        
        // Optional: Adjust row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    // MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCell", for: indexPath) as? MovieDetailCell else {
            return UITableViewCell()
        }
        
        // Configure the cell with movie data
        let movie = movies[indexPath.row]
        cell.movieName.text = movie.title
        cell.releaseDate.text = "Year: \(movie.year)"
        cell.langauge.text = "Languages: \(movie.language)"
        
        // Use Kingfisher to load the poster image asynchronously with placeholder
           if let url = URL(string: movie.poster) {
               cell.moviePoster.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
           }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Handle nested item selection
        let selectedMoview: MovieElement = movies[indexPath.row]
        // Navigate to MovieListViewController with filtered movies
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieListVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            movieListVC.selectedMovie = selectedMoview
            navigationController?.pushViewController(movieListVC, animated: true)
        }
    }
}
