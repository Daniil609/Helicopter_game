//
//  Artist.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 25/03/2021.
//

import Foundation

struct Artist:Codable {
    let id:String
    let name:String
    let type:String
    let images:[APIImage]?
    let external_urls:[String:String]
}
