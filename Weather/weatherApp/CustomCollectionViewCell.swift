
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    let dataFormat = "HH"
    func addText(hour:Hourly) {
        
        dateLabel.text = convertDat(time: "\(hour.dt)000", formatOfStr: dataFormat)
        temperatureLabel.text = "\(hour.temp)°C"
        for element  in hour.weather {
            descriptionLabel.text = element.description
        }
        print(hour.temp)
    }
    func convertDat(time:String, formatOfStr :String) -> String{
        if let theDate = Date(jsonDate: "/Date(\(time))/"){
            let format = DateFormatter()
            format.dateFormat = formatOfStr
            let time = format.string(from: theDate)
            return time
            
        } else {
            return "wrong format"
        }
    }
}
