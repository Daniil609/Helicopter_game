
import Foundation

class ManagerForSettings{
    
    static var shared = ManagerForSettings()
    private init (){}
    
    func saveResults(settings: Settings){
        var memorySettings = loadSettings()
        memorySettings = settings
        UserDefaults.standard.set(encodable: memorySettings, forKey: Keys.KeyForGame.rawValue)
    }
    
    func loadSettings() -> Settings {
        if let settings =  UserDefaults.standard.value(Settings.self, forKey: Keys.KeyForGame.rawValue) {
          return settings
        }else{
            return Settings(userName: "", helicopterName: "", birdName: "", gameSpeed: 2)
            
        }
    }
}
