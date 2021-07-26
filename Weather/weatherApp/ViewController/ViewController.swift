
import UIKit
import CoreLocation
import Charts
import SpriteKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController, ChartViewDelegate, CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    //MARK: - label
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var firstlabel: UILabel!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var maxMinFirstLabel: UILabel!
    @IBOutlet weak var maxMinSecondLabel: UILabel!
    @IBOutlet weak var nowTemperature: UILabel!
    @IBOutlet weak var therdLabel: UILabel!
    @IBOutlet weak var maxMinFifthLabel: UILabel!
    @IBOutlet weak var maxMinFourthLabel: UILabel!
    @IBOutlet weak var maxMinTherdLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var firstWearherDescription: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var secondWearherDescription: UILabel!
    @IBOutlet weak var maxminTemperature: UILabel!
    @IBOutlet weak var fourthWearherDescription: UILabel!
    @IBOutlet weak var fifthWearherDescription: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var thirdWearherDescription: UILabel!
    @IBOutlet weak var graphic: UIView!
    @IBOutlet weak var sunRiseLabel: UILabel!
    
    //MARK: - let
    let formatForSun = "HH:mm"
    let disposeBag = DisposeBag()
    let dataFormatForWeek = "EEEE"
    private var weather:Wheather? = nil
    private let locationManager  = CLLocationManager()
    
    //MARK: - var
    var lat:String?
    var cityNmae:String?
    var lon:String?
    var lineChart = LineChartView()
    var weatherFromJson = [Wheather]()
    
    //MARK: - vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        image.image = UIImage.gif(name: "sunny")
        image.addParalaxEffect()
        
        self.countryText.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map({
                self.countryText.text
            }) .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty{
                        self.displayWeather(nil)
                    }else{
                        self.convert(city: city)
                        self.cityNmae = city
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            self.fetchWeather(by: city)
                        }
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: - func
    private func fetchWeather(by city: String ){
        guard let _ = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL.weatherAPI(lat: lat ?? "" , lon: lon ?? "" ) else {
            return
        }
        let resourse = Resource<Wheather>(url: url)
        URLRequest.load(resourse: resourse)
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(Wheather.empty)
            .subscribe(onNext:{ result in
                let weather = result
                self.displayWeather(weather)
            }).disposed(by: disposeBag)
    }
    
    private func displayWeather (_ weather:Wheather?){
        if let weather = weather{
            print(weather.current.weather.description)
            let descr = weather.current.weather.description
            self.weather = weather
            collectionView.reloadData()
            self.humidityLabel.text = "\(weather.current.humidity)"
            self.pressureLabel.text = "\(weather.current.pressure)"
            self.sunSetLabel.text = convertDat(time: "\(weather.current.sunset)000", formatOfStr: formatForSun)
            self.sunRiseLabel.text = convertDat(time: "\(weather.current.sunrise)000", formatOfStr: formatForSun)
            self.windSpeedLabel.text = "\(weather.current.wind_speed)m/s"
            self.windDegreeLabel.text = "\(weather.current.wind_deg)"
            self.nowTemperature.text = "\(weather.current.temp)°C"
            self.feelsLike.text = "Fells:\(weather.current.feels_like)°C"
            self.weatherDescription.text = weather.current.weather.first?.description
            if let city = cityNmae{
                self.country.text = "\(city)"
            }
            var index = 0
            for element in weather.daily{
                switch index {
                case 0:
                    break
                case 1:
                    self.firstlabel.text = self.convertDat(time: "\(element.dt)000", formatOfStr: dataFormatForWeek)
                    self.firstWearherDescription.text = element.weather.first?.description
                case 2:
                    self.secondLabel.text = self.convertDat(time: "\(element.dt)000", formatOfStr: dataFormatForWeek)
                    self.secondWearherDescription.text = element.weather.first?.description
                case 3:
                    self.therdLabel.text = self.convertDat(time: "\(element.dt)000", formatOfStr: dataFormatForWeek)
                    self.thirdWearherDescription.text = element.weather.first?.description
                case 4:
                    self.fourthLabel.text = self.convertDat(time: "\(element.dt)000", formatOfStr: dataFormatForWeek)
                    self.fourthWearherDescription.text = element.weather.first?.description
                case 5:
                    self.fifthLabel.text = self.convertDat(time: "\(element.dt)000", formatOfStr: dataFormatForWeek)
                    self.fifthWearherDescription.text = element.weather.first?.description
                default:
                    break
                    
                }
                index += 1
            }
            index = 0
            for element in weather.daily{
                switch index {
                case 0:
                    break
                case 1:
                    self.maxMinFirstLabel.text = "\( String(element.temp.max ?? 0 ))° / \(String(element.temp.min ?? 0))°"
                    break
                case 2:
                    self.maxMinSecondLabel.text = "\( String(element.temp.max ?? 0 ))° / \(String(element.temp.min ?? 0))°"
                    break
                case 3:
                    self.maxMinTherdLabel.text = "\( String(element.temp.max ?? 0 ))° / \(String(element.temp.min ?? 0))°"
                    break
                case 4:
                    self.maxMinFourthLabel.text = "\( String(element.temp.max ?? 0 ))° / \(String(element.temp.min ?? 0))°"
                    break
                case 5:
                    self.maxMinFifthLabel.text = "\( String(element.temp.max ?? 0 ))° / \(String(element.temp.min ?? 0))°"
                    break
                default:
                    break
                }
                index += 1
            }
            index = 0
        }
        else{
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weather?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let hour = weather?.hourly{
            cell.addText(hour: hour[indexPath.item])
        }
        cell.layer.cornerRadius = 10
        return cell
    }
    
    private func convert(city:String)  {
        Manager.shared.getCoordinateFrom(address: city) { [weak self] (coordinate, error) in
            guard let coordinate = coordinate, error == nil else { return }
            self?.lat =  String(coordinate.latitude)
            self?.lon =  String(coordinate.longitude)
            DispatchQueue.main.async { [] in
                self?.lat =  String(coordinate.latitude)
                self?.lon =  String(coordinate.longitude)
            }
        }
    }
    
    private func convertDat(time:String, formatOfStr :String) -> String{
        if let theDate = Date(jsonDate: "/Date(\(time))/"){
            let format = DateFormatter()
            format.dateFormat = formatOfStr
            var time = format.string(from: theDate)
            return time
            
        } else {
            return "wrong format"
        }
    }
}
extension Date {
    init?(jsonDate: String) {
        
        let prefix = "/Date("
        let suffix = ")/"
        
        // Check for correct format:
        guard jsonDate.hasPrefix(prefix) && jsonDate.hasSuffix(suffix) else { return nil }
        
        // Extract the number as a string:
        let from = jsonDate.index(jsonDate.startIndex, offsetBy: prefix.count)
        let to = jsonDate.index(jsonDate.endIndex, offsetBy: -suffix.count)
        
        // Convert milliseconds to double
        guard let milliSeconds = Double(jsonDate[from ..< to]) else { return nil }
        
        // Create NSDate with this UNIX timestamp
        self.init(timeIntervalSince1970: milliSeconds/1000.0)
    }
}
extension UIView {
    func addParalaxEffect(amount: Int = 20) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        addMotionEffect(group)
    }
}





