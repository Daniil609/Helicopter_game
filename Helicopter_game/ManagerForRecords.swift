
import Foundation

class ManagerForRecords{
    static var shared = ManagerForRecords()
    private init(){}
    
    func saveResults(array: [Records]){
        var memoryArray = loadArray()
        memoryArray.append(contentsOf: array)
        UserDefaults.standard.set(encodable: memoryArray, forKey: Keys.KeyForResults.rawValue)
    }
    
    func loadArray() ->[Records] {
        if let resultArray =  UserDefaults.standard.value([Records].self, forKey: Keys.KeyForResults.rawValue) {
          return resultArray
        }else{return[]}
    }
}
