//
//  MoviesDetailViewController.swift
//  BrewAppsTask
//
//  Created by sainath on 03/12/21.
//

import UIKit

class MoviesDetailViewController: UIViewController {
    
    @IBOutlet weak var detailMovieImageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    var imageData = Data()
    var titleName:String?
    var releaseDate:String?
    var movieTitleDescription:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailMovieImageView.image = UIImage(data: imageData)
        movieName.text! = titleName ?? ""
        movieReleaseDate.text! = "Release Date: \(releaseDate ?? "")"
        movieDescription.text! = movieTitleDescription ?? ""
        self.view.overrideUserInterfaceStyle = .dark
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
