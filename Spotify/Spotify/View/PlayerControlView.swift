//
//  PlayerControlView.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 10/04/2021.
//

import Foundation
import UIKit

protocol PlayerControlViewDelegete:AnyObject {
    func PlayerControlViewDidTapPlayPauseButton(_ playerControlView: PlayerControlView)
    func PlayerControlViewDidTapForwardButton(_ playerControlView: PlayerControlView)
    func PlayerControlViewDidTapBackwardButton(_ playerControlView: PlayerControlView)
    func PlayerControlView(_ playerControlView: PlayerControlView,didSlideSlider value: Float)
}

struct PlayerControlViewViewModel {
    let title:String?
    let subtitle:String?
}

final class PlayerControlView:UIView{
    
    weak var delegete:PlayerControlViewDelegete?
    
    private var isPlaying = true
    
    private let volumeSlider:UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "name label cmdkmc "
        label.font = .systemFont(ofSize: 20,weight:.semibold)
        return label
    }()
    
    private let subtitleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "subtitle label cmdkmc "
        label.font = .systemFont(ofSize: 18,weight:.regular)
        return label
    }()
    
    private let backButton:UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton:UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton:UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(playPauseButton)
        addSubview(nextButton)
        
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        clipsToBounds = true
        
        
    }
    
    @objc func didSlideSlider(_ slider:UISlider){
        let value = slider.value
        delegete?.PlayerControlView(self, didSlideSlider: value)
    }
    
    @objc func didTapBack(){
        delegete?.PlayerControlViewDidTapBackwardButton(self)
    }
    @objc func didTapNext(){
        delegete?.PlayerControlViewDidTapForwardButton(self)

    }
    @objc func didTapPlayPause(){
        self.isPlaying = !isPlaying
        delegete?.PlayerControlViewDidTapPlayPauseButton(self)
        let pause = UIImage(systemName: "pause",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let play = UIImage(systemName: "play",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        playPauseButton.setImage(isPlaying ? pause:play, for: .normal)

    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.botton + 10 , width: width , height: 50 )
        
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.botton+20, width: width-20, height: 44)
        
        let buttonSize:CGFloat = 60
        
        playPauseButton.frame = CGRect(x: (width - buttonSize)/2, y: volumeSlider.botton + 30, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left-80-buttonSize, y:playPauseButton.top, width: buttonSize, height: buttonSize)
        nextButton.frame = CGRect(x:playPauseButton.right+80, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    }
    
    func configure(with viewModel:PlayerControlViewViewModel){
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}
