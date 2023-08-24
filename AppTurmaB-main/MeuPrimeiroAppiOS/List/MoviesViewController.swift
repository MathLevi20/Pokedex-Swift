import UIKit

class MoviesViewController: UIViewController {
    private var movies: [Pokedex] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Filmes Populares"
        return label
    }()
    
      
      private func appbar() {
          

      }
      
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
          // Create a navigation bar
          let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
          navigationBar.backgroundColor = .black
            
          
          // Create a navigation item
          let navigationItem = UINavigationItem(title: "My AppBar")
          
          // Assign the navigation item to the navigation bar
          navigationBar.items = [navigationItem]
          
          // Add the navigation bar to the view
          view.addSubview(navigationBar)
          view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
   
        addViewsInHierarchy()
        setupConstraints()
        fetchRemoteMovies()
    }
    
    private func addViewsInHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

      private func fetchRemoteMovies() {
          let url = URL(string: "")!
          
          let request = URLRequest(url: url)
          
          let task = URLSession.shared.dataTask(with: request) { data, _, error in
              if let error = error {
                  print("Error fetching data:", error)
                  return
              }
              
              guard let moviesData = data else {
                  print("No data received")
                  return
              }
              
              let decoder = JSONDecoder()
              decoder.keyDecodingStrategy = .convertFromSnakeCase
              
              do {
                    let remoteMovies = try decoder.decode(Pokedex.self ,from: moviesData)
                  print(remoteMovies)
                  self.Pokemon = remoteMovies
                  
                  DispatchQueue.main.async {
                      self.tableView.reloadData()
                  }
              } catch {
                  print("Error decoding JSON:", error)
              }
          }
          
          task.resume()
      }
      private func fetchRemoteMovies() {
            let url = URL(string:  "https://pokede.onrender.com/pokemon" )!

            let request = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if error != nil { return }

                guard let moviesData = data else { return }

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                guard let remoteMovies = try? decoder.decode(Pokemon.self, from: moviesData) else { return }
                  
                  self.movies = remoteMovies.[]

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }

            task.resume()
        }
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MovieCell()
        let movie = movies[indexPath.row]
          cell.configure(movie: Pokemon )
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Detail", bundle: Bundle(for: DetailViewController.self))
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        detailViewController.movie = movies[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
