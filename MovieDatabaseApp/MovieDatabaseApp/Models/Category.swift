//
//  Category.swift
//  MovieDatabaseApp
//
//  Created by Aryaveer Bajpai on 05/11/24.
//


enum Category: String, CaseIterable {
    case year = "Year"
    case genre = "Genre"
    case directors = "Directors"
    case actors = "Actors"
    case allMovies = "All Movies"
    
    // Optional: Method to get display names (if raw values aren’t display names)
    func displayName() -> String {
        return self.rawValue
    }
}

//// Assuming Category is an enum or a struct
//enum Category: CaseIterable {
//    case year, genre, directors, actors, allMovies
//
//    func displayName() -> String {
//        switch self {
//        case .year: return "Years"
//        case .genre: return "Genres"
//        case .directors: return "Directors"
//        case .actors: return "Actors"
//        case .allMovies: return "All Movies"
//        }
//    }
//}
