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
    func didUpdateGames(games : GameData )
    func didUpdateGames(gameDesc : GameDescription )
}

class GamesManager {
    

    var delegate : GamesManagerDelegate?
    var viewName : String?
    
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
                    if self.viewName == "ViewController" {
                        if let games = self.jsonDecode(gamesData: safeData){
                            self.delegate?.didUpdateGames(games: games)
                        }
                    }else{
                        if let gameDesc = self.jsonDecode(gamesDescription: safeData){
                            self.delegate?.didUpdateGames(gameDesc: gameDesc)
                        }
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
    
    func jsonDecode(gamesDescription : Data ) -> GameDescription? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(GameDescription.self , from: gamesDescription)
            return decodedData
        }catch{
            return nil
        }
    }
}

