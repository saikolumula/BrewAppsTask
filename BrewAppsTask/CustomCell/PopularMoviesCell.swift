//
//  PopularMoviesCell.swift
//  BrewAppsTask
//
//  Created by sainath on 03/12/21.
//

import UIKit

class PopularMoviesCell: UICollectionViewCell {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var PopularMovieImage: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var buttonPressed:(()->()) = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(white:1, alpha:0)
        imgView.backgroundColor = UIColor.clear
        imgView.isOpaque = false
        imgView.contentMode = .scaleAspectFit
        // Initialization code
    }
    @IBAction func deleteMovieButtonAction(_ sender: Any) {
        buttonPressed()
    }
}
