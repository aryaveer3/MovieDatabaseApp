//
//  MovieDetailViewController.swift
//  MovieDatabaseApp
//
//  Created by Aryaveer Bajpai on 06/11/24.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var movieName: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var movieDetail: UITextView!
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var ratingControl: UISegmentedControl!
    
    @IBOutlet weak var castAndCrew:  UILabel!
    
    @IBOutlet weak var genre: UILabel!
    
    var selectedMovie: MovieElement?
    
    // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if let movie = selectedMovie {
                configureView(with: movie)
            }
            
            // Set default rating based on the first segment (IMDB)
            updateRatingLabel(for: ratingControl.selectedSegmentIndex)
            
            // Add target for UISegmentedControl value changes
            ratingControl.addTarget(self, action: #selector(ratingControlChanged(_:)), for: .valueChanged)
        }
        
        // MARK: - Configure View with Movie Data
        private func configureView(with movie: MovieElement) {
            movieName.text = movie.title
            releaseDate.text = "Released:" + movie.released
            movieDetail.text = movie.plot
            genre.text = "Genre:" + movie.genre
            castAndCrew.text = "Cast & Crew:" + movie.actors + movie.director
            if let url = URL(string: movie.poster) {
                moviePoster.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            }
        }
        
        // MARK: - Update Rating Label Based on Segment Selection
        @objc private func ratingControlChanged(_ sender: UISegmentedControl) {
            updateRatingLabel(for: sender.selectedSegmentIndex)
        }
        
        private func updateRatingLabel(for index: Int) {
            guard let movie = selectedMovie else { return }
            
            // Check selected rating source
            let selectedRating: String
            switch index {
            case 0:
                // IMDB rating
                selectedRating = movie.ratings.first(where: { $0.source.rawValue == "Internet Movie Database" })?.value ?? "N/A"
            case 1:
                // Rotten Tomatoes rating
                selectedRating = movie.ratings.first(where: { $0.source.rawValue == "Rotten Tomatoes" })?.value ?? "N/A"
            case 2:
                // Metacritic rating
                selectedRating = movie.ratings.first(where: { $0.source.rawValue == "Metacritic" })?.value ?? "N/A"
            default:
                selectedRating = "N/A"
            }
            
            // Set the rating label to the selected rating
            rating.text = "Rating: \(selectedRating)"
        }

}
