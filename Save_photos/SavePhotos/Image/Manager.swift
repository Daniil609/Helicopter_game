import Foundation
import UIKit

class Manager{
    static let shared = Manager()
    
    var imageArray = [Image]()
    
    private init(){}
    
    func loadImage(fileName: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentsDirectory.appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    func save(imageName:String?, like:Bool?, comment:String?) {
        
        
        if let resultArray =  UserDefaults.standard.value([Image].self, forKey: Keys.KeyForImage.rawValue) {
            imageArray = resultArray
            imageArray.append(Image(imageName: imageName ?? "", like: like ?? false, comment: comment ?? ""))
            //        resultArrayNew.removeAll()
            UserDefaults.standard.set(encodable: imageArray, forKey: Keys.KeyForImage.rawValue)
            
        }else{
            imageArray.append(Image(imageName: imageName ?? "", like: like ?? false, comment: comment ?? ""))
            UserDefaults.standard.set(encodable: imageArray, forKey: Keys.KeyForImage.rawValue)
        }
    }
    
    func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let error {
                print("couldn't remove file at path", error)
            }
        }
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    func saveChangies()  {
        UserDefaults.standard.set(encodable: imageArray, forKey: Keys.KeyForImage.rawValue)
    }
    
    func loadArrayFromMemory() -> [Image] {
        if let resultArray =  UserDefaults.standard.value([Image].self, forKey: Keys.KeyForImage.rawValue) {
            imageArray = resultArray
            return resultArray
        }else{return[]}
    }
}
