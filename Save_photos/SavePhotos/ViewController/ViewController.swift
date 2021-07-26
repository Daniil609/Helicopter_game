
import UIKit
import SwiftyKeychainKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var loginBitton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - let
    let keychain = Keychain(service: "ht3ForLesson16.SavePhotos")
    let acces = KeychainKey<String>(key: "password")
    var enterPassword:String?
    
    //MARK: - var
    var attemptCount = 3
    var time = 3.0
    var timer = Timer()
    var password:String?
    
    //MARK: - vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = "left \(attemptCount) attempt"
        do {
            try? keychain.set("1234", for: acces)
        }catch let error{
            debugPrint(error)
        }
    }
    
    //MARK: - IBAction
    @IBAction func checkPassWord(_ sender: UIButton) {
        statusLabel.text = "left \(attemptCount) attempt"
        enterPassword = PasswordField.text
        if attemptCount == 1{
            createAlert()
            loginBitton.isEnabled = false
        }
        if let enterPassword  =  PasswordField.text  {
            do {
                let value = try keychain.get(acces)
                 password  = value
            } catch let error {
                debugPrint(error)
            }
            if password == enterPassword{
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "PickerViewController") as? PickerViewController else{
                    return
                }
                controller.modalTransitionStyle = .flipHorizontal
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                attemptCount -= 1
            }
        }
        statusLabel.text = "left \(attemptCount) attempt"
        statusLabel.textColor = .red
    }
    
    func createAlert()  {
        let alert = UIAlertController(title: "Input throught \(time)", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Enter again", style: .default) {  (_) in
            }
        alert.addAction(okAction)
        okAction.isEnabled = false
        self.present(alert, animated: true, completion: nil)

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] (timer) in
            time -= 1
            alert.title = "Input throught \(time)"
            if time == 0 {
                loginBitton.isEnabled = true
                timer.invalidate()
                attemptCount = 3
                statusLabel.text = "left \(attemptCount) attempt"
                okAction.isEnabled = true
                time = 3
            }
        }
    } 
}
extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}




