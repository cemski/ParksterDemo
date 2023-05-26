//
//  HomeCollectionViewCell.swift
//  ParksterDemo
//
//  Created by Cem on 2023-05-22.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
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
        contentView.layer.cornerRadius = contentView.bounds.height / 4
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 27, weight: .bold)
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
            imageView.topAnchor.constraint(lessThanOrEqualTo: topAnchor, constant: 15),
            imageView.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: 15),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35),
            
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    
    func configureCell(with item: HomeMenuItems) {
        let isFirst = HomeMenuItems.allCases.first == item

        contentView.backgroundColor = isFirst ? .primaryColor : .secondaryColor

        titleLabel.text = item.title
        titleLabel.textColor = isFirst ? .white : .primaryColor
        imageView.image = UIImage(systemName: item.symbol)?.withTintColor(isFirst ? .white : .primaryColor, renderingMode: .alwaysOriginal)
    }
}
