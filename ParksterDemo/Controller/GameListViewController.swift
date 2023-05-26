//
//  GameListViewController.swift
//  ParksterDemo
//
//  Created by Cem on 2023-05-23.
//

import UIKit

class GameListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    var games: [Game]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alla spel"
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games?.isEmpty == true ? 1 : games?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let allGames = games, !allGames.isEmpty {
            let game = allGames[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            
            config.text = "Game ID: \(game.id.prefix(4))...\(game.id.suffix(4))"
            let image = game.isPlayable ? UIImage(systemName: "hourglass")?.withTintColor(.label, renderingMode: .alwaysOriginal) :
                UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            config.image = image
            cell.contentConfiguration = config
            cell.accessoryType = .disclosureIndicator
            
            return cell
        } else {
            tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = "Inga tillgängliga spel"
            config.textProperties.alignment = .center
            config.textProperties.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            cell.contentConfiguration = config
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let game = games?[indexPath.row],
              let name = UserDefaults.standard.string(forKey: "playerName") else { return }
        
        if game.isPlayable {
            addPlayer(name: name, gameId: game.id) { result in
                switch result {
                case .success(let player):
                    DispatchQueue.main.async {
                        let vc = GameViewController()
                        vc.game = game
                        vc.player = player
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            guard let finishedRound = game.finishedRounds?.last else { return }
            
            getRound(gameId: game.id, roundId: finishedRound.id) { result in
                switch result {
                case .success(let round):
                    DispatchQueue.main.async {
                        let vc = GameViewController()
                        vc.game = game
                        vc.round = round
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
