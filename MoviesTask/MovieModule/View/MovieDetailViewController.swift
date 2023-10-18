//
//  MovieDetailViewController.swift
//  MoviesTask
//
//  Created by TejaDanasvi on 18/10/2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var overViewlbl: UILabel!
    @IBOutlet weak var descriptionlbl: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var datelbl: UILabel!

    var movie: CMovie!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie {
            setup(movie: movie)
        }
    }
    
    func setup(movie: CMovie) {
        if let image = movie.posterImage {
            movieImage.image = UIImage(data: image)
        }
        self.title = movie.title ?? ""
        descriptionlbl.text = movie.overview ?? ""
        datelbl.text = "Realease Date:  \(movie.release_date ?? "")"
    }
}

