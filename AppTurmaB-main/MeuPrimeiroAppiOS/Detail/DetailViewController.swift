import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    var movie: Pokedex!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieImageView.layer.cornerRadius = 8
        movieImageView.layer.masksToBounds = true
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.backgroundColor = .blue

        configure(with: Pokemon)
    }

    func configure(with movie: Pokemon) {
        movieTitle.text = movie.title
        movieImageView.download(path: movie.image)
        movieRating.text = "Classificação: \(movie.number)"
        movieDescription.text = movie.type
    }
}
