//
//  SerchRes.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 09/04/2021.
//

import Foundation
enum  SearchResult{
    case artist(model:Artist)
    case album(model :Album)
    case track(model :AudioTrack)
    case playlist(model :Playlist)
}
