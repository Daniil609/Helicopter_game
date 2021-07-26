
import UIKit
import SDWebImage

class NewReleseCollectionViewCell: UICollectionViewCell {
    static var identifier = "NewReleseCollectionViewCell"
    
    private let albumCoverImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight:.semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfTrackLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight:.thin)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight:.light)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumLabel)
        contentView.addSubview(numberOfTrackLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init(coder:NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        artistNameLabel.sizeToFit()
        numberOfTrackLabel.sizeToFit()
        let imageSize:CGFloat = contentView.hight - 10
        
        let albumLableSize = albumLabel.sizeThatFits(
            CGSize(
                width: contentView.width-imageSize-10,
                height: contentView.hight-10
            )
        )
        let albumLabelHight = min(60, albumLableSize.height)
        
        
        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 5,
            width: imageSize,
            height: imageSize
        )
        
        numberOfTrackLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: contentView.botton-44,
            width: numberOfTrackLabel.width,
            height: 44
        )
        albumLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: 5 ,
            width: albumLableSize.width,
            height: albumLabelHight
        )
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: albumLabel.botton,
            width:contentView.width - albumCoverImageView.right-10,
            height: 30
        )
        
       
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumLabel.text = nil
        artistNameLabel.text = nil
        numberOfTrackLabel.text = nil
        albumCoverImageView.image = nil
        
    }
    
    func configre(with viewModel:NewReleasesCellViewModel)  {
        albumLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTrackLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURl, completed: nil)
        
    }
}
