//
//  ViewController.swift
//  NoStoryTest
//
//  Created by Nursultan Konspayev on 27.04.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var themeCollectionView: UICollectionView = {
       let collection = UICollectionView()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 500
        tableView.separatorStyle = .none
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        return tableView
    }()
    
    //    var dataSource: [MovieTitle] = Array(repeating: MovieTitle(titleLabel: "Uncharted", image: UIImage(named: "movie")), count: 10)
    var movieData: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        setupLayout()
        NetworkManager.shared.loadMovie2() { result in
            DispatchQueue.main.async {
                self.movieData = result
                self.tableView.reloadData()
            }
        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
//        tableView.snp.makeConstraints { make in
//            make.top.bottom.leading.trailing.equalToSuperview()
//        }
    }
    
    func apiRequest() {
        let session = URLSession(configuration: .default)
        lazy var urlComponent: URLComponents = {
            var component = URLComponents()
            component.scheme = "https"
            component.host = "api.themoviedb.org"
            component.path = "/3/movie/upcoming"
            component.queryItems = [
                URLQueryItem(name: "api_key", value: "ced760785529022f787ac282841dc942")
            ]
            return component
        }()
        guard let requestUrl = urlComponent.url else { return }
        let task = session.dataTask(with: requestUrl) {
            data, response, error in
            guard let data = data else { return }
            if let movie = try? JSONDecoder().decode(Movie.self, from: data)
            {
                DispatchQueue.main.async {
                    self.movieData = movie.results
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        //        let movie = dataSource[indexPath.row]
        let title = movieData[indexPath.row].title
        let urlImageString = "https://image.tmdb.org/t/p/w500" + movieData[indexPath.row].posterPath
        if let url = URL(string: urlImageString) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url)
                {
                    DispatchQueue.main.async {
                        let movie = MovieTitle(titleLabel: title, image: UIImage(data: data))
                        cell.conf(movie: movie)
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieID = movieData[indexPath.row].id
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

