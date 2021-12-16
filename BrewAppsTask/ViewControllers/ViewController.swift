//
//  ViewController.swift
//  BrewAppsTask
//
//  Created by sainath on 03/12/21.
//

import UIKit
var filterData = [PopularMovie]()
class ViewController: UIViewController,UISearchBarDelegate {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    let path = "https://image.tmdb.org/t/p/w342"
    let poster = "https://image.tmdb.org/t/p/original"

    var popularMovies = [PopularMovie]()
    var popularMainMovies = [PopularMovie]()
    var repository = MoviesRespiratory()

    //MARK: - VIEW STATE
    
    var viewState = MoviesViewState.empty {
        didSet {
            moviesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        searchBar.delegate = self
        self.view.overrideUserInterfaceStyle = .dark
    }
    
    //MARK: - API CALL
    func loadData() {
        self.repository.executePopularApiCall { (result: Result<[PopularMovie], Error>) in
            switch result {
            case .success:
                self.viewState = self.generateViewState(movieTypes: self.repository.movies)
                
            case .failure:
                break
            }
        }
    }
    
    func removeSelectedRow(row: Int) {
        
        viewState.rows.remove(at: row)
        
        let indexPath = IndexPath(row: row, section: 0)
        
        self.moviesCollectionView.performBatchUpdates({
            viewState.rows.remove(at: indexPath.item)
            self.moviesCollectionView.deleteItems(at: [indexPath])
        }) { (finished) in
            
        }
    }
    
    // MARK: - Searchbar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.view.overrideUserInterfaceStyle = .light
        popularMovies = searchText.isEmpty ? filterData : filterData.filter{
            
            $0.title.range(of: searchText, options: .caseInsensitive) != nil ||
            $0.overview.range(of: searchText, options: .caseInsensitive) != nil
        }
        self.viewState = self.generateViewState(movieTypes: popularMovies)
        
        moviesCollectionView.reloadData()
        
    }
}

extension ViewController:UICollectionViewDelegate{
    
    //MARK:- Collectionview Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewState.rows[indexPath.row]
        
        var imagesUrl : URL!
        var movieName:String?
        var releaseDate:String?
        var movieDescription:String?
        
        switch data {
        case .popularMovie(let popularMovies):
            viewState = generateViewState(movieTypes: repository.movies)
            imagesUrl = URL(string: poster + popularMovies.posterPath)!
            movieName = popularMovies.title
            releaseDate = popularMovies.releaseDate
            movieDescription = popularMovies.overview

        case .unPopularMovie(let unpopularMovies):
            viewState = generateViewState(movieTypes: repository.movies)
            imagesUrl = URL(string: poster + unpopularMovies.posterPath)!
            movieName = unpopularMovies.title
            releaseDate = unpopularMovies.releaseDate
            movieDescription = unpopularMovies.overview

        default:
            break
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MoviesDetailViewController") as! MoviesDetailViewController
        vc.titleName = movieName
        vc.releaseDate = releaseDate
        vc.movieTitleDescription = movieDescription
        if let data = try? Data(contentsOf: imagesUrl!) {
            vc.imageData = data
        }

        self.present(vc, animated: false, completion: nil)
                
    }
}


extension ViewController:UICollectionViewDataSource{
    
    //MARK:- Collectionview DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         viewState.rows.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = viewState.rows[indexPath.row]
        switch data {
        case .popularMovie(let popularMovies):

            let cell: PopularMoviesCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            
            let url = URL(string: poster + popularMovies.posterPath)!

             //Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                cell.PopularMovieImage.image = UIImage(data: data)
            }
            
            if self.view.overrideUserInterfaceStyle == .dark{

                cell.btnDelete.setTitleColor(.white, for: .normal)

            }else{
                cell.btnDelete.setTitleColor(.black, for: .normal)

            }
            
            cell.buttonPressed = {

                self.removeSelectedRow(row: indexPath.row)
            }
            return cell

        case .unPopularMovie(let ratedMovies):

            let cell: UnPopularMoviesCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            
            cell.movieTitle.text = ratedMovies.originalTitle
            cell.movieDescription.text = ratedMovies.overview

            let url = URL(string: path + ratedMovies.posterPath)!

           // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                cell.movieImageView.image = UIImage(data: data)
            }
            
            cell.buttonPressed = {
                self.removeSelectedRow(row: indexPath.row)
            }
            
            if self.view.overrideUserInterfaceStyle == .dark{
                
                cell.btnDelete.setTitleColor(.white, for: .normal)
    
            }else{
                cell.btnDelete.setTitleColor(.black, for: .normal)
                
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    
    //MARK: -  CollectionFlowDeleagteLayOut  Deleagte And DataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        let frameCell = (self.moviesCollectionView.frame.size.width)
        let size = CGSize(width: frameCell, height: 300)
        return size

    }
}


extension ViewController {
    func generateViewState(movieTypes: [PopularMovie]) -> MoviesViewState {
        var rows = [MoviesViewState.Row]()
        for movie in movieTypes {
            if movie.voteAverage > 7 {
                rows.append(.popularMovie(movie))
            } else {
                rows.append(.unPopularMovie(movie))
            }
        }
        viewState.rows = rows
        return viewState
    }
}

