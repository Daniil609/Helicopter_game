//
//  AlbumTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 08/04/2021.
//

import Foundation
import UIKit
class AlbumTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlbumTrackCollectionViewCell"

    
    private let trackLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight:.regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,weight:.thin)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init(coder:NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        trackLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.width-15,
            height: contentView.hight/2
        )
        artistNameLabel.frame = CGRect(
            x: 10,
            y: contentView.hight/2,
            width: contentView.width-15,
            height: contentView.hight/2
        )
        
        
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackLabel.text = nil
        artistNameLabel.text = nil
        
    }
    
    func configre(with viewModel:AlbumCollectionViewModel)  {
        trackLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
      
    }
}
