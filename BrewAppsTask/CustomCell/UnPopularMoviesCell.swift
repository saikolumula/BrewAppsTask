//
//  UnPopularMoviesCell.swift
//  BrewAppsTask
//
//  Created by sainath on 03/12/21.
//

import UIKit

class UnPopularMoviesCell: UICollectionViewCell {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var buttonPressed:(()-> ()) = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func deleteMovieButtonAction(_ sender: Any) {
        buttonPressed()
    }
}
