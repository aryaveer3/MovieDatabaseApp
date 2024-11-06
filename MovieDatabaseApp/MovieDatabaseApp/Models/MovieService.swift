//
//  MovieService.swift
//  MovieDatabaseApp
//
//  Created by Aryaveer Bajpai on 05/11/24.
//

import Foundation

class MovieService {
    static func loadMovies() -> [MovieElement] {
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
            print("Failed to find movies.json in bundle.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let movies = try JSONDecoder().decode([MovieElement].self, from: data)
            return movies
        } catch {
            print("Failed to decode movies.json: \(error)")
            return []
        }
    }
}
