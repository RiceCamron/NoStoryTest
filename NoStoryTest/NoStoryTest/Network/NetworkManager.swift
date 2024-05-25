//
//  NetworkManager.swift
//  NoStoryTest
//
//  Created by Artur Avdeev on 22.05.2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let urlImage = "https://image.tmdb.org/t/p/w500"
    private let apiKey = "ced760785529022f787ac282841dc942"
    var movieData: [Result]?
    lazy var urlComponent: URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.themoviedb.org"
        component.queryItems = [
            URLQueryItem(name: "api_key", value: "ced760785529022f787ac282841dc942")
        ]
        return component
    }()
    let session = URLSession(configuration: .default)
    
    func loadMovie(theme: String, complaction: @escaping ([Result]) -> Void) {
        var component = urlComponent
        component.path = "/3/movie/upcoming"
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
//                    self.movieData = movie.results
//                    self.tableView.reloadData()
                    complaction(movie.results)
                }
            }
        }
        task.resume()
    }
}
