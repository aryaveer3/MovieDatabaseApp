import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var categories = Category.allCases
    var movies: [MovieElement] = MovieService.loadMovies()
    var filteredMovies: [MovieElement] = []
    
    private static let movieDetailCellIdentifier = "MovieDetailCell"
    private static let categoryCellIdentifier = "CategoryCell"


    // State management
    var isSearching = false // Tracks whether search is active
    
    // Unique values for each category
    var uniqueYears: [String] {
        Set(movies.map { $0.year }).sorted()
    }
    
    var uniqueGenres: [String] {
        let genres = movies.flatMap { $0.genre.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
        return Set(genres).sorted()
    }
    
    var uniqueDirectors: [String] {
        Set(movies.map { $0.director }).sorted()
    }
    
    var uniqueActors: [String] {
        let actors = movies.flatMap { $0.actors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
        return Set(actors).sorted()
    }
    
    // Track the expanded state of sections
    var expandedSections: [Category: Bool] = [
        .year: false,
        .genre: false,
        .directors: false,
        .actors: false,
        .allMovies: false
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register the custom cell nib
        let nib = UINib(nibName: "MovieDetailCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MovieDetailCell")
        tableView.reloadData()
        self.title = "Movie Database"
        // Set up search bar delegate
        searchBar.delegate = self
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredMovies.count
        } else {
            let category = categories[section]
            return expandedSections[category] == true ? (uniqueItemCount(for: category) + 1) : 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.movieDetailCellIdentifier, for: indexPath) as! MovieDetailCell
                    let movie = filteredMovies[indexPath.row]
                    configure(cell: cell, with: movie)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
            let category = categories[indexPath.section]
            
            if indexPath.row == 0 {
                // Header cell
                cell.textLabel?.text = category.displayName()
                cell.accessoryType = .disclosureIndicator
            } else {
                // Nested item cell
                cell.textLabel?.text = itemForCategory(category, at: indexPath.row - 1)
                cell.accessoryType = .none
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSearching {
            // Handle selection from search results
            let selectedMovie = filteredMovies[indexPath.row]
            
            // Navigate to MovieDetailViewController with the selected movie
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
                return
            }
            movieDetailVC.selectedMovie = selectedMovie
            navigationController?.pushViewController(movieDetailVC, animated: true)
            return
        }
        
        // Handle selection in the default categories view
        let category = categories[indexPath.section]

        if indexPath.row == 0 {
            toggleExpansion(for: category, at: indexPath)
        } else {
            // Handle nested item selection for filtering movies by category
            let selectedItem = itemForCategory(category, at: indexPath.row - 1) // Adjust for header row
            let filteredMovies = filterMovies(for: category, with: selectedItem)
            
            // Navigate to MovieListViewController with filtered movies
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let movieListVC = storyboard.instantiateViewController(withIdentifier: "MovieListViewController") as? MovieListViewController {
                movieListVC.movies = filteredMovies
                navigationController?.pushViewController(movieListVC, animated: true)
            }
        }
    }

    private func toggleExpansion(for category: Category, at indexPath: IndexPath) {
        expandedSections[category]?.toggle()
        let rowCount = uniqueItemCount(for: category)
        var indexPaths: [IndexPath] = []
        
        if expandedSections[category] == true {
            indexPaths = (1...rowCount).map { IndexPath(row: $0, section: indexPath.section) }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } else {
            indexPaths = (1...rowCount).map { IndexPath(row: $0, section: indexPath.section) }
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }

    
    // Helper Methods
    private func uniqueItemCount(for category: Category) -> Int {
        switch category {
        case .year:
            return uniqueYears.count
        case .genre:
            return uniqueGenres.count
        case .directors:
            return uniqueDirectors.count
        case .actors:
            return uniqueActors.count
        case .allMovies:
            return movies.count
        }
    }
    
    private func itemForCategory(_ category: Category, at index: Int) -> String {
        switch category {
        case .year:
            return uniqueYears[index]
        case .genre:
            return uniqueGenres[index]
        case .directors:
            return uniqueDirectors[index]
        case .actors:
            return uniqueActors[index]
        case .allMovies:
            return movies[index].title
        }
    }
    
    private func filterMovies(for category: Category, with item: String) -> [MovieElement] {
        switch category {
        case .year:
            return movies.filter { $0.year == item }
        case .genre:
            return movies.filter { $0.genre.contains(item) }
        case .directors:
            return movies.filter { $0.director == item }
        case .actors:
            return movies.filter { $0.actors.contains(item) }
        case .allMovies:
            return movies.filter { $0.title == item }
        }
    }
    
    private func configure(cell: MovieDetailCell, with movie: MovieElement) {
        cell.configure(with: movie)
    }

}

extension HomeViewController : UISearchBarDelegate{
    
    // MARK: - UISearchBarDelegate Methods
       
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filterMovies(with: searchText)
        }
        tableView.reloadData()
    }

       
   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       searchBar.text = ""
       isSearching = false
       tableView.reloadData()
       searchBar.resignFirstResponder() // Dismiss keyboard
   }
   
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       searchBar.resignFirstResponder() // Dismiss keyboard when search is tapped
   }
    
    private func filterMovies(with searchText: String) {
        let lowercasedSearchText = searchText.lowercased()
        filteredMovies = movies.filter { movie in
            return movie.title.lowercased().contains(lowercasedSearchText) ||
                   movie.genre.lowercased().contains(lowercasedSearchText) ||
                   movie.actors.lowercased().contains(lowercasedSearchText) ||
                   movie.director.lowercased().contains(lowercasedSearchText)
        }
    }

}
