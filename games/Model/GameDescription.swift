//
//  GameDescription.swift
//  games
//
//  Created by MAC on 27/12/2021.
//

import Foundation
import UIKit
// to use to send data to viewController to update the ui
protocol GameDescriptionDelegate {
    func didUpdateGames(gameDesc : GameDescription)
}

class GameDescrption {
    
    static let shared = GameDescrption()
    var delegate : GameDescriptionDelegate?
    
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
                    if let gameDesc = self.jsonDecode(gamesDescription: safeData){
                            self.delegate?.didUpdateGames(gameDesc: gameDesc)
                        }
                }
            }
            task.resume()
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
