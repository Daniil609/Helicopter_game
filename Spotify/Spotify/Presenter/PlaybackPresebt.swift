//
//  PlaybackPresebt.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 10/04/2021.
//
import AVFoundation
import Foundation
import UIKit

protocol PlayerDataSource:AnyObject {
    var songName:String? {get}
    var subtitle:String? {get}
    var imageURL:URL? {get}
}

final class PlaybackPresenter{
    
    static let shared = PlaybackPresenter()
    
    private var track:AudioTrack?
     var tracks = [AudioTrack]()
    var index = 0
    var playerVC:PlayerViewController?
    var player:AVPlayer?
    var playerQuene:AVQueuePlayer?
    
    var currentTrack:AudioTrack?{
        if let track = track, tracks.isEmpty{
            return track
        }else if let player = self.playerQuene, !tracks.isEmpty{
//            let item = player.currentItem
//            let items = player.items()
//            guard let index = items.firstIndex(where: {$0 == item}) else {
//                return nil
//            }
            return tracks[index]
        }
        return nil
    }
    
     func startPlayback(from viewCintroller: UIViewController,track:AudioTrack){
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.0
        let vc = PlayerViewController()
        self.track = track
        self.tracks = []
        vc.title = track.name
        vc.dataSourse = self
        vc.delegete = self
        viewCintroller.present( UINavigationController(rootViewController: vc), animated: true) {[weak self]  in
            self?.player?.play()
        }
        self.playerVC = vc
       
    }
    
     func startPlayback(from viewCintroller: UIViewController,tracks:[AudioTrack]){
        self.tracks = tracks
        self.track = nil
        
        self.playerQuene = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else{
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        
        self.playerQuene?.volume = 0
        self.playerQuene?.play()
        let vc = PlayerViewController()
        vc.dataSourse = self
        vc.delegete = self
        viewCintroller.present( UINavigationController(rootViewController: vc), animated: true) {[weak self]  in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
   
}
extension PlaybackPresenter:PlayerViewControllerDelegete {
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player{
            if player.timeControlStatus == .playing{
                player.pause()
            }else if player.timeControlStatus == .paused{
                player.play()
            }
        }else if let  player = playerQuene{
            if player.timeControlStatus == .playing{
                player.pause()
            }else if player.timeControlStatus == .paused{
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty{
            player?.pause()
        }else if let  player = playerQuene{
            playerQuene?.advanceToNextItem()
            index += 1
            print(index)
            

            
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty{
            player?.pause()
            player?.play()
        }else if let firstItem = playerQuene?.items().first {
            playerQuene?.pause()
            playerQuene?.removeAllItems()
            playerQuene = AVQueuePlayer(items: [firstItem])
            playerQuene?.play()
            playerQuene?.volume = 0
        }
    }
    
    
    
    
}
extension PlaybackPresenter:PlayerDataSource{
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")

    }
    
    
}
