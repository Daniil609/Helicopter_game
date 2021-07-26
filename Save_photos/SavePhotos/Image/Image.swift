
import Foundation
class Image: Codable {
    
    var imageName:String?
    var like:Bool?
    var comment:String?
    
    init(imageName:String,like:Bool,comment:String) {
        self.imageName = imageName
        self.like = like
        self.comment = comment
    }
    
    private enum CodingKeys: String, CodingKey {
        case imageName
        case like
        case comment
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
        like = try container.decodeIfPresent(Bool.self, forKey: .like)
        comment = try container.decodeIfPresent(String.self, forKey: .comment)
       
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.imageName, forKey: .imageName)
        try container.encode(self.like, forKey: .like)
        try container.encode(self.comment, forKey: .comment)
        
    }
}
extension UserDefaults {
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
