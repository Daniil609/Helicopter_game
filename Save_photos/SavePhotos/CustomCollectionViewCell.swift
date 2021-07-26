

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var image: UIImageView!
    
    //MARK: - func
    func addImge(object:UIImage)  {
        image.image = object
    }
}
