
import UIKit
enum Keys:String {
    case KeyForGame = "key"
    case KeyForResults = "Res"
}
class SettingsViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var choiseHelicopterButton: UIButton!
    @IBOutlet weak var settingsLAabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var helicopter: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var helicopterLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var bird: UIImageView!
    @IBOutlet weak var birdLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var numberOfSpeed: UILabel!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var lowValueOfSpeed: UILabel!
    @IBOutlet weak var maxValueOfSpee: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var choiseBirdButton: UIButton!
    
    //MARK: - let
    private let viewUpHelicopter = UIView()
    private let viewUpHelicopter2 = UIView()
    private let viewOfBurd = UIView()
    private let viewOfBird2 = UIView()
    private let viewForPicture = UIView()
    private  let viewForBirdPicture = UIView()
    private let backVeiw = UIView()
    private let helicopterPicture =  UIImageView(image: UIImage.gif(name: "helicopter"))
    private let helicopterPicture2 = UIImageView(image: UIImage.gif(name: "helicopter2"))
    private let birdPicture = UIImageView(image: UIImage.gif(name: "bird"))
    private let birdPicture2 = UIImageView(image: UIImage.gif(name: "newBird"))
    private let cancelForBird = UIButton()
    private let cancelButton = UIButton()
    
    //MARK: - var
    var hilecopterNmae = ""
    var birdNmae = ""
    var speed = 0
    var radius:CGFloat = 10
    var Name:String?
    
    //MARK: - VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInformation()
        styleOfButton()
        textOfButton()
        styleOfText()
        createViewForBird()
        createViewForHelicoprer()
        let recognizerForHelic = UITapGestureRecognizer(target: self, action: #selector(self.tapdetected(_:)))
        self.viewUpHelicopter.addGestureRecognizer(recognizerForHelic)
        
        let recognizerForHelic2 = UITapGestureRecognizer(target: self, action: #selector(self.tapdetectedtwo(_:)))
        self.viewUpHelicopter2.addGestureRecognizer(recognizerForHelic2)
        
        let recognizerForBird = UITapGestureRecognizer(target: self, action: #selector(self.tapdetectedBird(_:)))
        self.viewOfBurd.addGestureRecognizer(recognizerForBird)
        
        let recognizerForBird2 = UITapGestureRecognizer(target: self, action: #selector(self.tapdetectedBird2(_:)))
        self.viewOfBird2.addGestureRecognizer(recognizerForBird2)
    }
    
    //MARK: - Actions
    @IBAction func backButton(_ sender: UIButton) {
        let user = Settings(userName: Name, helicopterName: hilecopterNmae, birdName: birdNmae, gameSpeed: speed)
        ManagerForSettings.shared.saveResults(settings: user)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func choiseHelicopter(_ sender: UIButton) {
        animationForHelicopter()
    }
    
    @IBAction func choiseBird(_ sender: UIButton) {
        animationForBirdView()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        backAnimationForHelicopter()
    }
    
    @IBAction func changeSpeedValue(_ sender: UISlider) {
        speed = Int(sender.value)
        numberOfSpeed.text = "\(speed)"
    }
    
    @IBAction func cancelBird(_ sender: UIButton) {
        backAnimationForBird()
    }
    
    @IBAction func tapdetected(_ recognizer: UITapGestureRecognizer){
        backAnimationForHelicopter()
        helicopter.image = UIImage.gif(name: "helicopter")
        hilecopterNmae = "helicopter"
    }
    
    @IBAction func addName(_ sender: UIButton) {
        Name = userName.text
        settingsLAabel.adjustsFontSizeToFitWidth = true
        settingsLAabel.text = "Hellow \(Name ?? "")"
    }
    
    @IBAction func tapdetectedtwo(_ recognizer: UITapGestureRecognizer){
        backAnimationForHelicopter()
        helicopter.image = UIImage.gif(name: "helicopter2")
        hilecopterNmae = "helicopter2"
    }
    
    @IBAction func tapdetectedBird(_ recognizer: UITapGestureRecognizer){
        backAnimationForBird()
        bird.image = UIImage.gif(name: "bird")
        birdNmae = "bird"
    }
    
    @IBAction func tapdetectedBird2(_ recognizer: UITapGestureRecognizer){
        backAnimationForBird()
        bird.image = UIImage.gif(name: "newBird")
        birdNmae = "newBird"
    }
    
    //MARK: - func
    private func loadInformation() {
        let user = ManagerForSettings.shared.loadSettings()
        userName.text = user.userName
        bird.image = UIImage.gif(name: user.birdName ?? "")
        helicopter.image = UIImage.gif(name: user.helicopterName ?? "")
        numberOfSpeed.text = String(user.gameSpeed ?? 1)
    }
    private func createViewForHelicoprer()  {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 3, height: 5)
        shadow.shadowBlurRadius = 6
        
        viewForPicture.frame = CGRect(x: self.view.frame.width - self.viewForPicture.frame.width , y: self.view.frame.height/9, width: self.view.frame.width, height: self.view.frame.height/4)
        viewForPicture.backgroundColor = .gray
        self.view.addSubview(viewForPicture)
        
        cancelButton.frame = CGRect(x: self.viewForPicture.frame.width/3.5, y: self.viewForPicture.frame.height/1.3, width: self.viewForPicture.frame.width/2, height: self.viewForPicture.frame.height/6)
        cancelButton.backgroundColor = .systemYellow
        cancelButton.setTitle("Cancle", for: .normal)
        cancelButton.setTitleColor(.green, for: .normal)
        let textCancel = cancelButton.currentTitle ?? ""
        let attributeText:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 23) as Any,
                                                            NSAttributedString.Key.foregroundColor: UIColor.green,
                                                            NSAttributedString.Key.shadow: shadow
        ]
        let attibuteStringCancel = NSAttributedString(string: textCancel , attributes: attributeText)
        cancelButton.setAttributedTitle(attibuteStringCancel, for: .normal)
        cancelButton.titleLabel?.textAlignment = NSTextAlignment.center
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        self.viewForPicture.addSubview(cancelButton)
        
        helicopterPicture.frame = CGRect(x: self.viewForPicture.frame.origin.x/10, y: self.viewForPicture.frame.origin.y/15 , width: self.viewForPicture.frame.width/4, height:self.viewForPicture.frame.height/2)
        
        self.viewForPicture.addSubview(helicopterPicture)
        
        viewUpHelicopter.frame = CGRect(x: self.viewForPicture.frame.origin.x/10 , y: self.viewForPicture.frame.origin.y/15 , width: self.viewForPicture.frame.width/4, height: self.viewForPicture.frame.height/2)
        self.viewForPicture.addSubview(viewUpHelicopter)
        
        
        viewUpHelicopter2.frame = CGRect(x: self.viewForPicture.frame.origin.x/2 , y: self.viewForPicture.frame.origin.y/15 , width: self.viewForPicture.frame.width/2, height: self.viewForPicture.frame.height/2)
        self.viewForPicture.addSubview(viewUpHelicopter2)
        
        helicopterPicture2.frame = CGRect(x: self.viewForPicture.frame.origin.x/2 , y: self.viewForPicture.frame.origin.y/15 , width:  self.viewForPicture.frame.width/2, height:self.viewForPicture.frame.height/2)
        self.viewForPicture.addSubview(helicopterPicture2)
    }
    
    private func createViewForBird()  {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 3, height: 5)
        shadow.shadowBlurRadius = 6
        
        viewForBirdPicture.frame = CGRect(x: self.view.frame.width - self.viewForPicture.frame.width , y: self.view.frame.height/1.8, width: self.view.frame.width, height: self.view.frame.height/4)
        viewForBirdPicture.backgroundColor = .lightGray
        self.view.addSubview(viewForBirdPicture)
        
        birdPicture.frame = CGRect(x:self.viewForBirdPicture.frame.origin.x/10, y:  self.viewForBirdPicture.frame.origin.y/15,width: self.viewForBirdPicture.frame.width/4, height:self.viewForBirdPicture.frame.height/2)
        self.viewForBirdPicture.addSubview(birdPicture)
        
        viewOfBurd.frame = CGRect(x:self.viewForBirdPicture.frame.origin.x/10, y:  self.viewForBirdPicture.frame.origin.y/15,width: self.viewForBirdPicture.frame.width/4, height:self.viewForBirdPicture.frame.height/2)
        self.viewForBirdPicture.addSubview(viewOfBurd)
        
        viewOfBird2.frame = CGRect(x: self.viewForBirdPicture.frame.origin.x/2 , y: self.viewForBirdPicture.frame.origin.y/15 , width: self.viewForBirdPicture.frame.width/2, height: self.viewForBirdPicture.frame.height/2)
        self.viewForBirdPicture.addSubview(viewOfBird2)
        
        birdPicture2.frame = CGRect(x: self.viewForBirdPicture.frame.origin.x/2 , y: self.viewForBirdPicture.frame.origin.y/15 , width: self.viewForBirdPicture.frame.width/2, height: self.viewForBirdPicture.frame.height/2)
        self.viewForBirdPicture.addSubview(birdPicture2)
        
        cancelForBird.frame = CGRect(x: self.viewForBirdPicture.frame.width/3.5, y: self.viewForBirdPicture.frame.height/1.3, width: self.viewForBirdPicture.frame.width/2, height: self.viewForBirdPicture.frame.height/6)
        cancelForBird.backgroundColor = .systemYellow
        cancelForBird.setTitle("Cancle", for: .normal)
        cancelForBird.setTitleColor(.green, for: .normal)
        let textCancel = cancelForBird.currentTitle ?? ""
        let attributeText:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 23) as Any,
                                                            NSAttributedString.Key.foregroundColor: UIColor.green,
                                                            NSAttributedString.Key.shadow: shadow
        ]
        let attibuteStringCancel = NSAttributedString(string: textCancel , attributes: attributeText)
        cancelForBird.setAttributedTitle(attibuteStringCancel, for: .normal)
        cancelForBird.titleLabel?.textAlignment = NSTextAlignment.center
        cancelForBird.addTarget(self, action: #selector(cancelBird(_:)), for: .touchUpInside)
        self.viewForBirdPicture.addSubview(cancelForBird) 
    }
    
    private func animationForBirdView()  {
        UIView.animate(withDuration: 2) {
            self.viewForBirdPicture.frame.origin.x = self.view.frame.width - self.viewForPicture.frame.width
        }
    }
    
    private func backAnimationForBird()  {
        UIView.animate(withDuration: 2) {
            self.viewForBirdPicture.frame.origin.x = self.view.frame.width + self.viewForPicture.frame.width
        }
    }
    
    private func animationForHelicopter()  {
        UIView.animate(withDuration: 2) {
            self.viewForPicture.frame.origin.x = self.view.frame.width - self.viewForPicture.frame.width
        }
    }
    
    private func choiseFirstHelicopter()  {
        backVeiw.frame = CGRect(x: self.viewForPicture.frame.origin.x/10 - 20, y: self.viewForPicture.frame.origin.y/10 - 20, width: self.viewForPicture.frame.width/2 + 20, height:self.viewForPicture.frame.height/2 + 20)
        backVeiw.backgroundColor = .blue
        backVeiw.backgroundColor = .blue
        self.viewForPicture.addSubview(backVeiw)
        self.viewForPicture.addSubview(helicopterPicture)
        
    }
    
    private func choiseSecondHelicopter()  {
        backVeiw.frame = CGRect(x: self.viewForPicture.frame.origin.x/2 , y: self.viewForPicture.frame.origin.y/10 - 20, width: self.viewForPicture.frame.width/2 + 20, height:self.viewForPicture.frame.height/2 + 20)
        backVeiw.backgroundColor = .blue
        backVeiw.backgroundColor = .blue
        self.viewForPicture.addSubview(backVeiw)
        self.viewForPicture.addSubview(helicopterPicture)
        
    }
    
    private func backAnimationForHelicopter()  {
        UIView.animate(withDuration: 2) {
            self.viewForPicture.frame.origin.x = self.view.frame.width + self.viewForPicture.frame.width
        }
    }
    
    private func styleOfText()  {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 3, height: 5)
        shadow.shadowBlurRadius = 6
        
        let textOfNameLable = nameLabel.text ?? ""
        let textOfHelicopterLable = helicopterLabel.text ?? ""
        let textOfBirdLable = birdLabel.text ?? ""
        let textOfSpeed = speedLabel.text ?? ""
        let textOfSettings = settingsLAabel.text ?? ""
        let textNumberOfSpeed = numberOfSpeed.text ?? ""
        let textNumberOfmax = maxValueOfSpee.text ?? ""
        let textNumberOfmix = lowValueOfSpeed.text ?? ""
        
        let attributeText:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 30) as Any,
                                                            NSAttributedString.Key.foregroundColor: UIColor.green,
                                                            NSAttributedString.Key.shadow: shadow
        ]
        let attributeTextName = NSAttributedString(string:textOfNameLable , attributes: attributeText)
        nameLabel.attributedText = attributeTextName
        let attributeTextHelicopter = NSAttributedString(string:textOfHelicopterLable , attributes: attributeText)
        helicopterLabel.attributedText = attributeTextHelicopter
        helicopterLabel.textAlignment = .center
        let attributeTextBird = NSAttributedString(string:textOfBirdLable , attributes: attributeText)
        birdLabel.textAlignment = .center
        birdLabel.attributedText = attributeTextBird
        let attributeTextSpeed = NSAttributedString(string:textOfSpeed , attributes: attributeText)
        speedLabel.attributedText = attributeTextSpeed
        let attributeTextNumberOfSpeed = NSAttributedString(string:textNumberOfSpeed , attributes: attributeText)
        numberOfSpeed.attributedText = attributeTextNumberOfSpeed
        let attributeTextNumberOfMax = NSAttributedString(string:textNumberOfmax , attributes: attributeText)
        maxValueOfSpee.attributedText = attributeTextNumberOfMax
        let attributeTextNumberOfSpeedMin = NSAttributedString(string:textNumberOfmix , attributes: attributeText)
        lowValueOfSpeed.attributedText = attributeTextNumberOfSpeedMin
        
        settingsLAabel.attributedText = NSMutableAttributedString(string: textOfSettings, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 60) ?? "",
            NSAttributedString.Key.foregroundColor: UIColor.green,
            NSAttributedString.Key.shadow: shadow
        ])
    }
    
    private func styleOfButton()  {
        choiseHelicopterButton.layer.cornerRadius = radius
        choiseBirdButton.layer.cornerRadius = radius
        backButton.layer.cornerRadius = radius
        cancelButton.layer.cornerRadius = radius
        cancelForBird.layer.cornerRadius = radius
    }
    
    private func textOfButton()  {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 3, height: 5)
        shadow.shadowBlurRadius = 6
        
        let textOfBack = backButton.currentTitle ?? ""
        let textOfBird = choiseBirdButton.currentTitle ?? ""
        let textOfHelicopter = choiseHelicopterButton.currentTitle ?? ""
        let textCancel = cancelButton.currentTitle ?? ""
        let attributeText:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 23) as Any,
                                                            NSAttributedString.Key.foregroundColor: UIColor.green,
                                                            NSAttributedString.Key.shadow: shadow
        ]
        let attibuteStringBack = NSAttributedString(string: textOfBack , attributes: attributeText)
        let attibuteStringBird = NSAttributedString(string: textOfBird , attributes: attributeText)
        let attibuteStringHelicopter = NSAttributedString(string: textOfHelicopter , attributes: attributeText)
        let attibuteStringCancel = NSAttributedString(string: textCancel , attributes: attributeText)
        backButton.setAttributedTitle(attibuteStringBack, for: .normal)
        backButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        cancelButton.setAttributedTitle(attibuteStringCancel, for: .normal)
        cancelButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        choiseBirdButton.setAttributedTitle(attibuteStringBird, for: .normal)
        choiseBirdButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        choiseHelicopterButton.setAttributedTitle(attibuteStringHelicopter, for: .normal)
        choiseHelicopterButton.titleLabel?.textAlignment = NSTextAlignment.center
        
    }
}
extension SettingsViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        var settings = ManagerForSettings.shared.loadSettings()
        Name = userName.text
        return true
    }
}
