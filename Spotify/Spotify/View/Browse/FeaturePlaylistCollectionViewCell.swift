import UIKit

class FeaturePlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturePlaylistCollectionViewCell"
    
    private let playlistCoverImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight:.regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let createrNameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,weight:.thin)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistLabel)
        contentView.addSubview(createrNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init(coder:NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        createrNameLabel.frame = CGRect(
            x: 3,
            y: contentView.hight-30,
            width: contentView.width-6,
            height: 30
        )
        playlistLabel.frame = CGRect(
            x: 3,
            y: contentView.hight-60,
            width: contentView.width-6,
            height: 30
        )
        let imageSize = contentView.hight-70
        playlistCoverImageView.frame = CGRect(
            x: (contentView.width-imageSize)/2,
            y: 3,
            width: imageSize,
            height: imageSize
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistLabel.text = nil
        createrNameLabel.text = nil
        playlistCoverImageView.image = nil
        
    }
    
    func configre(with viewModel:FeaturePlaylistCellViewModel)  {
        playlistLabel.text = viewModel.name
        createrNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
    }
}
