//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 22/04/2021.
//

import UIKit
protocol LibraryToggleViewDelegete:AnyObject {
    func libraryToggleViewDelegeteTapPlaylists(_ toggleView:LibraryToggleView)
    func libraryToggleViewDelegeteTapAlbums(_ toggleView:LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    var state:State = .playlist
    weak var delegete:LibraryToggleViewDelegete?

    private let playlistButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistButton)
        addSubview(albumButton)
        addSubview(indicatorView)
        playlistButton.addTarget(self, action: #selector(didTapPlaylist), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumButton.frame = CGRect(x: playlistButton.right, y: 0, width: 100, height: 40)
       
        layoutIndicator()
    }
    
    @objc func didTapPlaylist(){
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegete?.libraryToggleViewDelegeteTapPlaylists(self)
    }
    @objc func didTapAlbums(){
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegete?.libraryToggleViewDelegeteTapAlbums(self)
    }
    
    func layoutIndicator()  {
        
         switch state {
         case .album:
             indicatorView.frame = CGRect(x: 100, y: playlistButton.botton, width: 100, height: 3)
         case .playlist:
             indicatorView.frame = CGRect(x: 0, y: playlistButton.botton, width: 100, height: 3)
         }
         
    }
    
    func update(for state:State)  {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
