
import UIKit

class RecomendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecomendedTrackCollectionViewCell"

    private let albumCoverImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
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
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init(coder:NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 2,
            width: contentView.hight-4,
            height: contentView.hight-4
        )
        trackLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: 0,
            width: contentView.width-albumCoverImageView.right-15,
            height: contentView.hight/2
        )
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: contentView.hight/2,
            width: contentView.width-albumCoverImageView.right-15,
            height: contentView.hight/2
        )
        
        
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
        
    }
    
    func configre(with viewModel:RecomendedTrackCellViewModel)  {
        trackLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
