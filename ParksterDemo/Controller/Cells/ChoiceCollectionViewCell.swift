//
//  ChoiceCollectionViewCell.swift
//  ParksterDemo
//
//  Created by Cem on 2023-05-22.
//

import UIKit

class ChoiceCollectionViewCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    
    private var titleLabel: UILabel!
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
        backgroundColor = .primaryColor
        layer.cornerRadius = bounds.height/4
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
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
            
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -15),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureCell(choice: GameMenuItems) {
        titleLabel.text = choice.title
        imageView.image = UIImage(systemName: choice.symbol)?.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
}
