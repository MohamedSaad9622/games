//
//  Constants.swift
//  games
//
//  Created by MAC on 27/12/2021.
//

import Foundation

class Constants {
    static let shared = Constants()
    let url = "https://api.rawg.io/api/games?key=81f92c650c3b4ab8b3cb270a82276aae&dates=2021-01-01,2021-09-30&ordering=-rating"
    let searchUrl = "https://api.rawg.io/api/games?key=81f92c650c3b4ab8b3cb270a82276aae&dates=2021-01-01,2021-09-30&ordering=-rating&search="
    
    let gameCell_Identifier = "gameCell_Identifier"
    let GameCellNibName = "GameTableViewCell"
    let DetailsStoryboard = "DetailsStoryboard"
    let DetailsStoryboardID = "DetailsStoryboardID"
    
    // to recieve games list from GamesManager
    var gamesList = [Results]()
    // the link for next 20 games (next list)
    var nextGamesList : String?
    var searchLink : String?
    var gameIndex : Int?
    // to save image data to show in GameViewController without need to reload this data again
    var imageData : Data?
    var showMoreGames = false
    var searchTest = false
    var imageStr : String?

}
