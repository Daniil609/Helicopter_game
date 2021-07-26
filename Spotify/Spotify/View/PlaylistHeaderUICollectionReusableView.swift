
import SDWebImage
import UIKit

protocol PlaylistHeaderUICollectionReusableViewDelegete:AnyObject {
    func PlaylistHeaderUICollectionReusableViewDidTapAll(_ header:PlaylistHeaderUICollectionReusableView)
}
 
final class PlaylistHeaderUICollectionReusableView: UICollectionReusableView {
        static let identifier = "PlaylistHeaderUICollectionReusableView"
    weak var delegete:PlaylistHeaderUICollectionReusableViewDelegete?
    
    private let nameLabel:UILabel={
        let label = UILabel()
        label.font = .systemFont(ofSize: 23,weight:.semibold)
        return label
    }()
    private let descriptionLabel:UILabel={
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18,weight:.regular)
        label.numberOfLines = 0
        return label
    }()
    private let ownerLabel:UILabel={
        let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight:.light)
        return label
    }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(imageView)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize:CGFloat = hight/1.8
        imageView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        
        nameLabel.frame = CGRect(x: 10, y: imageView.botton, width: width-20, height: 44)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.botton, width: width-20, height: 44)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.botton, width: width-20, height: 44)
        playAllButton.frame = CGRect(x:width-80, y: hight-80, width: 60, height: 60)
    }
    @objc func didTapPlayAll(){
        delegete?.PlaylistHeaderUICollectionReusableViewDidTapAll(self)
    }
    func configure(with viewModel: PlaylistHeaderViewModel){
        nameLabel.text = viewModel.playlistName
        ownerLabel.text = viewModel.owner
        descriptionLabel.text = viewModel.description
        imageView.sd_setImage(with: viewModel.artWorkURL,placeholderImage: UIImage(systemName: "photo"), completed: nil)
    }
}
