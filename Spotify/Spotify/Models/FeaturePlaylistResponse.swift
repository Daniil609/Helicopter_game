//
//  FeaturePlaylistResponse.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 26/03/2021.
//

import Foundation

struct FeaturePlaylistResponse:Codable {
    let playlists:PlaylistResponse
}

struct CategoryPlayListResponse:Codable {
    let playlists:PlaylistResponse
}

struct PlaylistResponse:Codable {
    let items:[Playlist]
}

struct User:Codable {
    let display_name:String
    let external_urls:[String:String]
    let id:String
    
}
