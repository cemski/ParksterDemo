//
//  GameViewController.swift
//  ParksterDemo
//
//  Created by Cem on 2023-05-22.
//

import UIKit

class GameViewController: UIViewController {
    var game: Game?
    var player: Player?
    var round: Round?
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ChoiceCollectionViewCell.self, forCellWithReuseIdentifier: ChoiceCollectionViewCell.identifier)
        collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3, constant: layout.minimumInteritemSpacing * CGFloat(GameMenuItems.allCases.count)),
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func calculateResult(for round: Round) -> GameResult? {
        guard let player1Move = round.player1Move, let player2Move = round.player2Move else { return nil }
        
        if player1Move == player2Move {
            return .draw
        } else if (player1Move == .ROCK && player2Move == .SCISSOR) ||
                    (player1Move == .PAPER && player2Move == .ROCK) ||
                    (player1Move == .SCISSOR && player2Move == .PAPER) {
            return .win
        } else {
            return .lose
        }
    }
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let choice = GameMenuItems(rawValue: indexPath.item),
              let gameId = game?.id,
              let playerId = player?.id,
              let cell = collectionView.cellForItem(at: indexPath) as? ChoiceCollectionViewCell
        else { return }

        UIView.animate(withDuration: 0.1) {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }

        makeMove(choice: choice.data, gameId: gameId, playerId: playerId) { [weak self] result in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = GameSections(rawValue: indexPath.section) else { fatalError("Section out of bounds") }

        switch section {
        case .choices:
            guard let choice = GameMenuItems(rawValue: indexPath.row) else { fatalError("Row is out of bounds") }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChoiceCollectionViewCell.identifier, for: indexPath) as! ChoiceCollectionViewCell
            cell.configureCell(choice: choice)
            return cell

        case .result:
            guard let round = round,
                  let result = calculateResult(for: round),
                  let player1 = game?.player1?.name,
                  let player2 = game?.player2?.name
            else { return UICollectionViewCell() }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
            cell.configureCell(result: result, winner: player1, loser: player2)
            return cell
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = GameSections(rawValue: section) else { fatalError("Section out of bounds") }

        switch section {
        case .choices:
            return round == nil ? GameMenuItems.allCases.count : 0
        case .result:
            return round == nil ? 0 : 1
        }
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = GameSections(rawValue: indexPath.section) else { fatalError("Section out of bounds") }

        switch section {
        case .choices:
            return CGSize(width: collectionView.frame.width, height: view.frame.height * 0.1)
        case .result:
            return CGSize(width: collectionView.frame.width, height: view.frame.height * 0.3)
        }
    }
}

enum GameSections: Int, CaseIterable {
    case choices, result
}

enum GameMenuItems: Int, CaseIterable {
    case rock, scissors, paper

    var title: String {
        switch self {
        case .rock:
            return "Sten"
        case .scissors:
            return "Sax"
        case .paper:
            return "Påse"
        }
    }

    var symbol: String {
        switch self {
        case .rock:
            return "circle.circle.fill"
        case .scissors:
            return "scissors.circle.fill"
        case .paper:
            return "doc.circle.fill"
        }
    }

    var data: String {
        switch self {
        case .rock:
            return "ROCK"
        case .scissors:
            return "SCISSOR"
        case .paper:
            return "PAPER"
        }
    }
}

enum GameResult: String {
    case win = "vann"
    case lose = "förlorade"
    case draw = "Oavgjort"
}
