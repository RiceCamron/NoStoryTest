//
//  MoviceCell.swift
//  NoStoryTest
//
//  Created by Nursultan Konspayev on 06.05.2024.
//

import UIKit

class MovieCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
//        image.frame.size.width = 309
//        image.frame.size.height = 424
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 30
        image.bounds = .init(x: 20, y: 20, width: 309, height: 424)
        image.backgroundColor = .black
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func conf(movie: MovieTitle) {
        titleLabel.text = movie.titleLabel
        movieImage.image = movie.image
    }
    
    private func setupLayout() {
        let movieStackView = UIStackView(arrangedSubviews: [movieImage, titleLabel])
        movieStackView.translatesAutoresizingMaskIntoConstraints = false
        movieStackView.axis = .vertical
        movieStackView.spacing = 12
        contentView.addSubview(movieStackView)
        NSLayoutConstraint.activate([
            movieStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            movieStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            movieStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
