
import UIKit
import SDWebImage




class SearchResultUbtiteTableViewCell: UITableViewCell {

    static let identifier = "SearchResultUbtiteTableViewCell"
    
    private let label:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitlelabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(subtitlelabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        let imageSize:CGFloat = contentView.hight-10
        iconImageView.frame = CGRect(x: 10, y: 0, width: imageSize, height: imageSize)
//        iconImageView.layer.cornerRadius = imageSize/2
//        iconImageView.layer.masksToBounds = true
        let labelHieght = contentView.hight/2
        label.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width-iconImageView.right-15,
            height: labelHieght
        )
        subtitlelabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: label.botton,
            width: contentView.width-iconImageView.right-15,
            height: labelHieght
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subtitlelabel.text = nil
    }
    
    func configure(with viewModel:SearchResultSubtiteTableViewCellViewModel){
        label.text = viewModel.title
        subtitlelabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL,placeholderImage: UIImage(systemName: "photo") ,completed: nil)
    }
}
