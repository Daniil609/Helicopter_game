import Foundation
class Records: Codable {
    
    var resultOfGame:Int?
    var date:String?
    
    init(resultOfGame: Int, date:String) {
        self.resultOfGame = resultOfGame
        self.date = date
    }
    
    private enum CodingKeys: String, CodingKey {
        case resultOfGame
        case date
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try container.decodeIfPresent(String.self, forKey: .date)
        resultOfGame = try container.decodeIfPresent(Int.self, forKey: .resultOfGame) 
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.date, forKey: .date)
        try container.encode(self.resultOfGame, forKey: .resultOfGame)
    }
    
}


