
import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var index:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func fillingTable(object:Records,index:Int)  {
        dateLabel.text = object.date 
        resultLabel.text = String(object.resultOfGame ?? 0)
        indexLabel.text = String(index+1)
       
    }
}
