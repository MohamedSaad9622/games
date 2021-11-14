//
//  GameData.swift
//  games
//
//  Created by MAC on 04/11/2021.
//

import Foundation

struct GameData : Codable {
//    let count : Int
    let next : String
    let results : [Results]
}

struct Results : Codable {
    let name : String
    let background_image : String
    let rating : Double
    let id : Int
    // for gameDescription
}

struct GameDescription : Codable {
    let website : String
    let description_raw : String
}
