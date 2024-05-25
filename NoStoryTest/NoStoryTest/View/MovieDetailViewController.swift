//
//  MovieDetailViewController.swift
//  NoStoryTest
//
//  Created by Artur Avdeev on 15.05.2024.
//

import UIKit
import SnapKit

class MovieDetailViewController: UIViewController {
    var movieData: MovieDetail?
    var movieID = 0
    let urlImage = "https://image.tmdb.org/t/p/w500"
    lazy var scrollMovieDetail: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 30
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var realeseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    lazy var genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collection.backgroundColor = .blue
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Movie"
        apiRequest()
        setupLayout()
    }
    
    func apiRequest() {
        let session = URLSession(configuration: .default)
        lazy var urlComponent: URLComponents = {
            var component = URLComponents()
            component.scheme = "https"
            component.host = "api.themoviedb.org"
            component.path = "/3/movie/\(movieID)"
            component.queryItems = [
                URLQueryItem(name: "api_key", value: "ced760785529022f787ac282841dc942")
            ]
            return component
        }()
        
        guard let requestUrl = urlComponent.url else { return }
        let task = session.dataTask(with: requestUrl) {
            data, response, error in
            guard let data = data else { return }
            if let movie = try? JSONDecoder().decode(MovieDetail.self, from: data)
            {
                DispatchQueue.main.async {
                    self.movieData = movie
                    self.content()
                }
            }
        }
        task.resume()
    }
    
    func setupLayout() {
        lazy var stackReleaseView: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            return stackView
        }()
        
        view.addSubview(scrollMovieDetail)
        scrollMovieDetail.addSubview(movieImage)
        scrollMovieDetail.addSubview(titleLabel)
        scrollMovieDetail.addSubview(stackReleaseView)
        stackReleaseView.addArrangedSubview(realeseDateLabel)
        stackReleaseView.addArrangedSubview(genreCollectionView)
        
        NSLayoutConstraint.activate([
            scrollMovieDetail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollMovieDetail.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollMovieDetail.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollMovieDetail.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            movieImage.topAnchor.constraint(equalTo: scrollMovieDetail.topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: scrollMovieDetail.leadingAnchor, constant: 32),
            movieImage.trailingAnchor.constraint(equalTo: scrollMovieDetail.trailingAnchor, constant: -32),
            movieImage.widthAnchor.constraint(equalToConstant: 309),
            movieImage.heightAnchor.constraint(equalToConstant: 424),
            titleLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 17),
            titleLabel.leadingAnchor.constraint(equalTo: scrollMovieDetail.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: scrollMovieDetail.trailingAnchor, constant: -32),
            stackReleaseView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 17),
            stackReleaseView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 32),
            stackReleaseView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -32),
            stackReleaseView.bottomAnchor.constraint(equalTo: scrollMovieDetail.bottomAnchor, constant: -17),
            
        ])
        
        realeseDateLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        genreCollectionView.snp.makeConstraints{ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(realeseDateLabel.snp.bottom)
            make.height.equalTo(22)
        }
    }
    
    func content() {
        guard let movieData = movieData else {return}
        titleLabel.text = movieData.originalTitle
        realeseDateLabel.text = "Release Data \(movieData.releaseDate ?? "Not anonce")"
        let urlString = urlImage+movieData.posterPath!
        let url = URL(string: urlString)
        DispatchQueue.global(qos: .userInteractive).async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    self.movieImage.image = UIImage(data: data)
                }
            }
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieData?.genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as! GenreCollectionViewCell
        guard let genre = movieData?.genres?[indexPath.row].name else { return UICollectionViewCell() }
        cell.label.text = genre
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 22)
    }
}
