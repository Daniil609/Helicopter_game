//
//  NewReleasesRespons.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 26/03/2021.
//

import Foundation

struct NewReleasesRespons:Codable {
    let albums: AlbomsRespons
}

struct AlbomsRespons:Codable {
    let items:[Album]
}

struct Album :Codable{
    let album_type:String
    let available_markets:[String]
    let id:String
    var images:[APIImage]
    let name:String
    let release_date:String
    let total_tracks:Int
    let artists:[Artist]
}

