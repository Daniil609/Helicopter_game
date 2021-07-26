
import Foundation
import CoreLocation

extension URL{
    static func weatherAPI(lat:String,lon:String) -> URL?{
       
        return URL(string: "http://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&lang=ru&appid=2db04aad257975da99d12d993e98e374")
    }
    static func weatherImage(name:String)->URL?{
        return URL(string: "http://openweathermap.org/img/wn/\(name)@2x.png")
    }
}
