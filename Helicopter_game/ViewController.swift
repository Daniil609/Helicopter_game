import UIKit


class ViewController: UIViewController {

    //MARK: - UIButton
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var recorrdsButton: UIButton!
    @IBOutlet weak var settiingsbutton: UIButton!
    @IBOutlet weak var welcomeLable: UILabel!
    
    //MARK: - var
    var pilotName = ""
   
    
    //MARK: - VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        styleOfButton()
        styleOfText()
        loadInformatoin()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadInformatoin()
    }
    
    //MARK: - Actions
    @IBAction func startButton(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as? StartViewController else{
            return
        }
        controller.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func recordsButton(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "RecordsViewController") as? RecordsViewController else{
            return
        }
        controller.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else{
            return
        }
        controller.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func loadInformatoin()  {
        
        
        pilotName = ManagerForSettings.shared.loadSettings().userName ?? ""
        welcomeLable.text = NSLocalizedString("Welcome\(pilotName)", comment: "")

    }
    
    func styleOfText()  {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 3, height: 5)
        shadow.shadowBlurRadius = 6
        let textOfStart = startButton.currentTitle ?? ""
        let textOfSettings = settiingsbutton.currentTitle ?? ""
        let textOfRecords = recorrdsButton.currentTitle ?? ""
        welcomeLable.text = "Welcome"
        welcomeLable.textAlignment = .center
        welcomeLable.adjustsFontSizeToFitWidth = true
        let welcomeText = welcomeLable.text ?? ""
        let attributeText:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 40) as Any,
                                                            NSAttributedString.Key.foregroundColor: UIColor.green,
                                                            NSAttributedString.Key.shadow: shadow
                                                             
                
        ]
        let attibuteStringStart = NSAttributedString(string: textOfStart , attributes: attributeText)
        let attibuteStringRecords = NSAttributedString(string: textOfRecords , attributes: attributeText)
        let attibuteStringSettings = NSAttributedString(string: textOfSettings , attributes: attributeText)
        let attibuteStringWelcome = NSAttributedString(string: welcomeText , attributes: attributeText)
        welcomeLable.attributedText = attibuteStringWelcome
        startButton.setAttributedTitle(attibuteStringStart, for: .normal)
        startButton.titleLabel?.textAlignment = NSTextAlignment.center
        recorrdsButton.setAttributedTitle(attibuteStringRecords, for: .normal)
        recorrdsButton.titleLabel?.textAlignment = NSTextAlignment.center
        settiingsbutton.setAttributedTitle(attibuteStringSettings, for: .normal)
        settiingsbutton.titleLabel?.textAlignment = NSTextAlignment.center
        
    }
    
    private func styleOfButton()  {
        startButton.cornerRadius()
        settiingsbutton.cornerRadius()
        recorrdsButton.cornerRadius()
        startButton.dropShadow()
        settiingsbutton.dropShadow()
        recorrdsButton.dropShadow()
    }
}
extension UIView{
    func cornerRadius() {
        self.layer.cornerRadius = 15
    }
    func dropShadow(_ radius: CGFloat = 15) {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: 20, height: 20)
            layer.shadowRadius = 15
            layer.cornerRadius = radius
            
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
            layer.shouldRasterize = true
        }
}

