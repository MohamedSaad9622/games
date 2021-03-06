//
//  GamesManager.swift
//  games
//
//  Created by MAC on 05/11/2021.
//

import Foundation
import UIKit
// to use to send data to viewController to update the ui
protocol GamesManagerDelegate {
    func didUpdateGames(games : GameData)
}

class GamesManager {
    
    static let shared = GamesManager()
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
                            self.delegate?.didUpdateGames(games: games)
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
            let decodedData = try decoder.decode( GameData.self , from: gamesData)
            return decodedData
        }catch{
            return nil
        }
    }
}

