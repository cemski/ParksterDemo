//
//  HomeViewController.swift
//  ParksterDemo
//
//  Created by Cem on 2023-05-22.
//

import UIKit

class HomeViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let playerNameKey = "playerName"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        checkAndShowEnterNamePopup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Huvudmeny"
    }
    
    
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
    }
    
    private func checkAndShowEnterNamePopup() {
        if UserDefaults.standard.string(forKey: playerNameKey) == nil {
            showEnterNamePopup()
        }
    }
    
    private func showEnterNamePopup() {
        let popUpView = PopUpView(frame: view.bounds)
        view.addSubview(popUpView)
    }
    
    private func joinGameWithPlayer(gameData: Game) {
        guard let name = UserDefaults.standard.string(forKey: playerNameKey) else { return }
        addPlayer(name: name, gameId: gameData.id) { [weak self] result in
            switch result {
            case .success(let playerData):
                DispatchQueue.main.async {
//                    self?.collectionView.isUserInteractionEnabled = true
                    let gameVC = GameViewController()
                    gameVC.game = gameData
                    gameVC.player = playerData
                    self?.navigationController?.pushViewController(gameVC, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = HomeMenuItems(rawValue: indexPath.item) else {
            fatalError("Out of bounds")
        }
        
        collectionView.isUserInteractionEnabled = false
        
        switch item {
        case .new:
            createGame { [weak self] result in
                switch result {
                case .success(let gameData):
                    self?.joinGameWithPlayer(gameData: gameData)
                    DispatchQueue.main.async {
                        collectionView.isUserInteractionEnabled = true
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case .load:
            getGames { [weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        collectionView.isUserInteractionEnabled = true
                        let gameListVC = GameListViewController()
                        gameListVC.games = data
                        self?.navigationController?.pushViewController(gameListVC, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeMenuItems.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = HomeMenuItems(rawValue: indexPath.item) else {
            fatalError("Item out of bounds")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        cell.configureCell(with: item)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width * 0.44
        let height = view.frame.height * 0.15
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

enum HomeMenuItems: Int, CaseIterable {
    case new, load
    
    var title: String {
        switch self {
        case .new:
            return "Nytt Spel"
        case .load:
            return "Ladda Spel"
        }
    }
    
    var symbol: String {
        switch self {
        case .new:
            return "plus.app.fill"
        case .load:
            return "square.and.arrow.down.fill"
        }
    }
}

extension UIColor {
    static let primaryColor: UIColor = UIColor(named: "primaryColor")!
    static let secondaryColor: UIColor = UIColor(named: "secondaryColor")!
}
