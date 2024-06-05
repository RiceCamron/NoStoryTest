//
//  FavoriteViewController.swift
//  MovieDB
//
//  Created by Artur Avdeev on 27.05.2024.
//

import UIKit
import SnapKit

class FavoriteViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Favorite"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    
    lazy var movieTableView: UITableView = {
        let table = UITableView()
            table.delegate = self
            table.dataSource = self
            table.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
            return table
    }()
    
    var movieData: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(movieTableView)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(41)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(42)
        }
        
        movieTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).inset(28)
            make.bottom.trailing.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath)
        return cell
    }
    
    
}
