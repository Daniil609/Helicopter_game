
import Foundation

struct Wheather:Codable {
    var daily:[Daily]
    var current:Current
    var hourly:[Hourly]
}
extension Wheather{
    static var empty:Wheather{
        return Wheather(daily: [Daily(dt: 0, temp: Temp(day: 0, eve: 0, max: 0, min: 0, morn: 0, night: 0), weather: [WeatherInformation(description: "", icon: "")])], current: Current(dt: 0, feels_like: 0, humidity: 0, pressure: 0, temp: 0, wind_deg: 0, sunset: 0, sunrise: 0, wind_speed: 0, weather: [WeatherInformation(description: "", icon: "")]), hourly: [Hourly(dt: 0, temp: 0, weather: [WeatherInformation(description: "", icon: "")])])
    }
}
struct Hourly:Codable {
    let dt:Int
    let temp:Double
    let weather:[WeatherInformation]
}

struct Current:Codable {
    let dt:Double
    let feels_like:Double
    let humidity:Int
    let pressure:Int
    let temp:Double
    let wind_deg:Int
    let sunset:Int
    let sunrise:Int
    let wind_speed:Double
    let weather:[WeatherInformation]
    
}

struct Daily:Codable {
    let dt:Int
    let temp:Temp
    let weather:[WeatherInformation]
}


struct Temp:Codable {
    var day:Double?
    var eve:Double?
    var max:Double?
    var min:Double?
    var morn:Double?
    var night:Double?
}

struct WeatherInformation:Codable {
    let description:String
    let icon:String
}
