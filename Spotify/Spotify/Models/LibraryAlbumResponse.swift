//
//  LibraryAlbumResponse.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 04/05/2021.
//

import Foundation
struct LibraryAlbumResponse:Codable {
    let items:[SAveAlbum]
}
struct SAveAlbum:Codable {
    let added_at:String
    let album:Album
}
