import UIKit

extension UIImageView {
    func download(path: String) {
        guard let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + path) else {
            return
        }

        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                return
            }

            DispatchQueue.main.async {
                self.image = image
            }
        }

        task.resume()
    }
}
