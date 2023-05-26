//
//  GameResponse.swift
//  ParksterDemo
//
//  Created by Cem on 2023-05-22.
//

import Foundation

let baseurl = "https://rps-api-ujymak7y3a-ew.a.run.app"

struct Game: Codable {
    let id: String
    let player1: Player?
    let player2: Player?
    let currentRound: Round?
    let finishedRounds: [Round]?
    
    var isPlayable: Bool {
        guard let round = self.currentRound else { return false }
        return (round.player1Move == nil || round.player2Move == nil) || (self.player1 == nil || self.player2 == nil)
    }
}

struct Player: Codable {
    let id: String
    let name: String
}

struct Round: Codable {
    let id: String
    let player1Move: Choice?
    let player2Move: Choice?
}

enum Choice: String, Codable {
    case ROCK
    case PAPER
    case SCISSOR
    
    var choice: GameMenuItems {
        switch self {
        case .ROCK:
            return GameMenuItems.rock
        case .PAPER:
            return GameMenuItems.paper
        case .SCISSOR:
            return GameMenuItems.scissors
        }
    }
}

enum HTTPMethod: String {
    case GET
    case POST
}

func performRequest(url: URL, method: HTTPMethod, body: [String: Any]? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    
    if let body = body {
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let error = NSError(domain: "cemlapovski.ParksterDemo", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            let error = NSError(domain: "cemlapovski.ParksterDemo", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
            completion(.failure(error))
            return
        }
        
        completion(.success(data))
    }
    
    task.resume()
}

func getGames(completion: @escaping (Result<[Game], Error>) -> Void) {
    let url = URL(string: baseurl + "/games")!
    
    performRequest(url: url, method: .GET) { result in
        switch result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let games = try decoder.decode([Game].self, from: data)
                completion(.success(games))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

func createGame(completion: @escaping (Result<Game, Error>) -> Void) {
    let url = URL(string: baseurl + "/games")!
    
    performRequest(url: url, method: .POST) { result in
        switch result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let gameResponse = try decoder.decode(Game.self, from: data)
                completion(.success(gameResponse))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

func addPlayer(name: String, gameId: String, completion: @escaping (Result<Player, Error>) -> Void) {
    let url = URL(string: baseurl + "/games/\(gameId)/addPlayer")!
    let body = ["name": name]
    
    performRequest(url: url, method: .POST, body: body) { result in
        switch result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let playerResponse = try decoder.decode(Player.self, from: data)
                completion(.success(playerResponse))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

func makeMove(choice: String, gameId: String, playerId: String, completion: @escaping (Result<Round, Error>) -> Void) {
    let url = URL(string: baseurl + "/games/\(gameId)/doMove")!
    let body = ["playerId": playerId, "move": choice]
    
    performRequest(url: url, method: .POST, body: body) { result in
        switch result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let roundResponse = try decoder.decode(Round.self, from: data)
                completion(.success(roundResponse))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

func getRound(gameId: String, roundId: String, completion: @escaping (Result<Round, Error>) -> Void) {
    let url = URL(string: baseurl + "/games/\(gameId)/round/\(roundId)")!
    
    performRequest(url: url, method: .GET) { result in
        switch result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let roundResponse = try decoder.decode(Round.self, from: data)
                completion(.success(roundResponse))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
