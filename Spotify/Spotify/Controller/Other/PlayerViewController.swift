//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 25/03/2021.
//

import UIKit

protocol PlayerViewControllerDelegete:AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value:Float)
}

class PlayerViewController: UIViewController {

    weak var dataSourse:PlayerDataSource?
    weak var delegete:PlayerViewControllerDelegete?
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlsView = Spotify.PlayerControlView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegete = self
        configureButton()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(x: 10, y: imageView.botton+10, width: view.width-20, height: view.hight-imageView.hight-view.safeAreaInsets.top - 15)
    }
  
    private func configureButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    private func configure(){
        imageView.sd_setImage(with: dataSourse?.imageURL, completed: nil)
        controlsView.configure(with: PlayerControlViewViewModel(title: dataSourse?.songName, subtitle: dataSourse?.subtitle))
    }
    
    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    @objc func didTapAction(){
        
    }
    func refreshUI()  {
        configure()
    }
}
extension PlayerViewController: PlayerControlViewDelegete{
    func PlayerControlView(_ playerControlView: PlayerControlView, didSlideSlider value: Float) {
        delegete?.didSlideSlider(value)
    }
    
    func PlayerControlViewDidTapPlayPauseButton(_ playerControlView: PlayerControlView) {
        delegete?.didTapPlayPause()
    }
    
    func PlayerControlViewDidTapForwardButton(_ playerControlView: PlayerControlView) {
        delegete?.didTapForward()
    }
    
    func PlayerControlViewDidTapBackwardButton(_ playerControlView: PlayerControlView) {
        delegete?.didTapBackward()
    }
    
    
}
