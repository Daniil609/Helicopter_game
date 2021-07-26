
import Foundation
class Settings: Codable {
    var userName: String?
    var helicopterName: String?
    var birdName: String?
    var gameSpeed:Int? = 0
    
    init(userName: String?, helicopterName: String?, birdName:String?, gameSpeed: Int?) {
        self.userName = userName
        self.helicopterName = helicopterName
        self.birdName = birdName
        self.gameSpeed = gameSpeed
    }

    private enum CodingKeys: String, CodingKey {
        case userName
        case helicopterName
        case birdName
        case gameSpeed
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userName = try container.decodeIfPresent(String.self, forKey: .userName)
        helicopterName = try container.decodeIfPresent(String.self, forKey: .helicopterName)
        birdName = try container.decodeIfPresent(String.self, forKey: .birdName)
        gameSpeed = try container.decodeIfPresent(Int.self, forKey: .gameSpeed)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userName, forKey: .userName)
        try container.encode(self.helicopterName, forKey: .helicopterName)
        try container.encode(self.birdName, forKey: .birdName)
        try container.encode(self.gameSpeed, forKey: .gameSpeed)
    }
}
