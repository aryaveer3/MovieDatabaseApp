//
//  MovieDetailCell.swift
//  MovieDatabaseApp
//
//  Created by Aryaveer Bajpai on 06/11/24.
//

import UIKit

class MovieDetailCell: UITableViewCell {

    @IBOutlet weak var movieName: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var langauge: UILabel!
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with movie: MovieElement) {
        movieName.text = movie.title
        releaseDate.text = "Year: \(movie.year)"
        langauge.text = "Languages: \(movie.language)"
        
        if let url = URL(string: movie.poster) {
            moviePoster.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
    }

}
