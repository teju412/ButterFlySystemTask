//
//  MovieTableViewCell.swift
//  MoviesTask
//
//  Created by TejaDanasvi on 18/10/2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(movie: CMovie) {
        if let image = movie.posterImage {
            img.image = UIImage(data: image)
        }
        titleLbl.text = movie.title ?? ""
        releaseDateLbl.text = movie.release_date
    }
}

