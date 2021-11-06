//
//  GamesManager.swift
//  games
//
//  Created by MAC on 05/11/2021.
//

import Foundation
// to use to send data to viewController to update the ui
protocol GamesManagerDelegate {
    func didUpdateGames(games : GameData , nextGamesList : String)
}

class GamesManager {
    

    var delegate : GamesManagerDelegate?
    // to fetch data from api
    func performRequest(with url : String) {
        
        if let urlString = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, response, error in
                if error != nil {
                    print(error)
                    return
                }
                if let safeData = data {
                    if let games = self.jsonDecode(gamesData: safeData){
                        self.delegate?.didUpdateGames(games: games, nextGamesList: games.next)
                    }
                    
                }
            }
            task.resume()
        }
        
    }

    // decode data we get from url
    func jsonDecode (gamesData : Data) -> GameData? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(GameData.self , from: gamesData)
            let gamesData = GameData(next: decodedData.next, results: decodedData.results)
            return gamesData
            
        }catch{
            return nil
        }
    }
}

