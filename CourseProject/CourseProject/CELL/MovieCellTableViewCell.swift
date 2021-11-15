import UIKit
import SDWebImage

class MovieCellTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
   func configureWith(_ item: Movie) {
        if let newReleaseDate = item.release_date?.replacingOccurrences(of: "-", with: " ") ?? item.first_air_date?.replacingOccurrences(of: "-", with: " ") {
            self.movieReleaseDate.text = newReleaseDate
        }
        if let movieTitle = item.original_title ?? item.original_name ?? item.title {
            self.movieTitle.text = movieTitle
        }
        if let posterPath = item.poster_path {
            let imageURLString = "https://image.tmdb.org/t/p/w500/" + posterPath
            let imageURL = URL(string: imageURLString)
            self.moviePosterImage.sd_setImage(with: imageURL, completed: nil)
        }
    }
}
