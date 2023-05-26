//
//  ResultCollectionViewCell.swift
//  ParksterDemo
//
//  Created by Cem on 2023-05-24.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    
    private var winnerNameLabel: UILabel!
    private var resultLabel: UILabel!
    private var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .primaryColor
        contentView.layer.cornerRadius = bounds.height/4
        
        winnerNameLabel = UILabel()
        winnerNameLabel.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        winnerNameLabel.textColor = .white
        winnerNameLabel.minimumScaleFactor = 0.5
        winnerNameLabel.adjustsFontSizeToFitWidth = true
        winnerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(winnerNameLabel)
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            winnerNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25),
            winnerNameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            winnerNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -15),
            winnerNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureCell(result: GameResult, winner: String, loser: String) {
        winnerNameLabel.text = "\(winner) \(result.rawValue) mot \(loser)"
        imageView.image = UIImage(systemName: "trophy.fill")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
    }
}
