
import UIKit
import CoreMotion

class StartViewController: UIViewController {
    
    //MARK: - let
    private let back = UIImageView()
    private let newBack = UIImageView()
    private let rightRock = UIImageView()
    private let leftRock = UIImageView()
    private let helicopter = UIImageView()
    private let buttonRight = UIButton()
    private let buttonLeft = UIButton()
    private let barrier = UIImageView()
    private let statusbar = PlainProgressBar()
    private let newleftRock = UIImageView()
    private let newrightRock = UIImageView()
    private let imageViewGif = UIImageView(image: UIImage.gif(name: "smoke") )
    private let flag = UIImageView(image: UIImage.gif(name: "flag") )
    private let topBar = UIView()
    private let buttonHight = 50.0
    private let buttonWidht = 100.0
    private let sizeOfTree:CGFloat = 60.0
    private let distantNumber = UITextField()
    let date = Date()
    
    //MARK: - var
    var step:CGFloat = 15
    var positionHelicopterX:CGFloat = 0.0
    var positionHelicopterY:CGFloat = 0.0
    var towerArray = [UIImageView] ()
    var birdArray = [UIImageView]()
    var fuilLavel = 0.0
    var distant = 0
    var fuilArray = [UIImageView]()
    var nameOfHelicopter = "helicopter"
    var nameOfUser = ""
    var speed = 0
    var resultArrayOld = [Int]()
    var resultArrayNew = [Records]()
    var nameOfBird = "bird"
    weak  var Timer1:Timer?
    var timerDistan:Timer?
    var towerTimer:Timer?
    var birdTimer:Timer?
    var fuilTimer:Timer?
    var soundTimer:Timer?
    var timeBack = 5.0
    var firstBackTime = 10.0
    var birdFlyTime = 5.5
    var timeOfFuil = 5.5
    var timeOfFuilLavel = 1.0
    var createTowerTime = 2.5
    var animationOfTower = 5.0
    var animationOfFuil = 5.0
    var animationOfBird = 3.0
    var saveTime:String?
    var motionManager = CMMotionManager()
    var animationOfHelicopter = 0.3

    //MARK: - VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInformatoin()
        speedOfGame()
        helicopter.image =  UIImage.gif(name: nameOfHelicopter )
        gameTimer()
        playSound()
        changeValueFuel()
        createBack()
        createNewBack()
        createTower()
        addFuil()
        createHelicopter()
        birdFly()
        addGif()
        createButtons()
        animationForBack()
        createTopBar()
        move()
    }

    
    
    //MARK: - Actions
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightButton(_ sender: UIButton) {
        UIView.animate(withDuration: animationOfHelicopter) { [self] in
            crashMoveRight()
        } completion: { (_) in}
    }
    
    @IBAction func leftButton(_ sender: UIButton) {
        UIView.animate(withDuration: animationOfHelicopter) { [self] in
            crashMoveLeft()
        } completion: { (_) in}
    }
    
    //MARK: - func
    private func gameTimer()  {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [self] (timer) in
            for element in towerArray{
                if let tower = element.layer.presentation()?.frame{
                    if tower.intersects(self.helicopter.frame){
                        endOfGame()
                    }
                }
            }
            for element in birdArray{
                if let bird = element.layer.presentation()?.frame{
                    if bird.intersects(self.helicopter.frame){
                        endOfGame()
                    }
                }
            }
            for element in fuilArray{
                if let fuil = element.layer.presentation()?.frame{
                    if fuil.intersects(self.helicopter.frame){
                        element.removeFromSuperview()
                        fuilLavel = 0.0
                        
                    }
                }
            }
        }
        timerDistan = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [self] (timer) in
            distant += 1
            distantNumber.text = " \(distant) M"
        }
    }
    
    private func endOfGame()  {
        timerDistan?.invalidate()
        Timer1?.invalidate()
        birdTimer?.invalidate()
        fuilTimer?.invalidate()
        towerTimer?.invalidate()
        towerArray.removeAll()
        birdArray.removeAll()
        if player?.isPlaying == true{
        player?.stop()
        player?.currentTime = 0
        }
        saveResults()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func saveResults(){
        let format = DateFormatter()
        var resultArrayNew = [Records]()
        format.dateFormat = "HH:mm / dd.MM.yyyy"
        saveTime = format.string(from: Date())
        resultArrayNew.append(Records(resultOfGame: distant, date: saveTime ?? ""))
        ManagerForRecords.shared.saveResults(array: resultArrayNew)
    }
    
    private func loadInformatoin()  {
        var settings = ManagerForSettings.shared.loadSettings()
        if ((settings.helicopterName?.isEmpty) != nil){
            nameOfHelicopter = "helicopter"
        }else{
            nameOfHelicopter = settings.helicopterName ?? "helicopter"
        }
        if  ((settings.birdName?.isEmpty) != nil){
            nameOfBird = "bird"
        }else{
            nameOfBird = settings.birdName ?? "bird"
        }
        if ((settings.userName?.isEmpty) != nil){
            nameOfUser = "pol"
        }else{
            nameOfUser = settings.userName ?? "pol"
        }
        speed = settings.gameSpeed ?? 2
    }
    
    private func crashMoveRight() {
        if helicopter.frame.origin.x + helicopter.frame.width + CGFloat(step) > rightRock.frame.origin.x{
            endOfGame()
            self.navigationController?.popViewController(animated: true)
            
        }else{
            self.positionHelicopterX += step
            helicopter.frame.origin.x += step
            imageViewGif.frame.origin.x += step
        }
    }
    
    private func crashMoveLeft()  {
        if helicopter.frame.origin.x - CGFloat(step) < leftRock.frame.width{
            endOfGame()
            self.navigationController?.popViewController(animated: true)
        }else{
            self.positionHelicopterX -= step
            helicopter.frame.origin.x -= step
            imageViewGif.frame.origin.x -= step
        }
    }
    
    private func createTree()  {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [self] (timer) in
            let tree = UIImageView(image: #imageLiteral(resourceName: "tree"))
            tree.frame = CGRect(x: CGFloat.random(in: self.leftRock.frame.width ... self.rightRock.frame.origin.x - sizeOfTree), y:self.view.frame.origin.y - sizeOfTree, width: sizeOfTree, height: sizeOfTree)
            tree.backgroundColor = .green
            self.view.addSubview(tree)
            
            UIView.animate(withDuration: animationOfTower, delay: 0, options: .curveLinear) {
                tree.frame.origin.y = self.view.frame.height
            } completion: { (_) in
                tree.removeFromSuperview()
            }
        }
    }
    
    private func createTower()  {
        towerTimer = Timer.scheduledTimer(withTimeInterval: createTowerTime, repeats: true) { [self] (timer) in
            let tower = UIImageView(image: #imageLiteral(resourceName: "tower"))
            tower.frame = CGRect(x: CGFloat.random(in: self.leftRock.frame.width ... self.rightRock.frame.origin.x - self.view.frame.width/7), y:self.view.frame.origin.y - self.view.frame.height/9, width: self.view.frame.width/7, height: self.view.frame.height/9)
            self.view.addSubview(tower)
            towerArray.append(tower)
            UIView.animate(withDuration: animationOfTower, delay: 0, options: .curveLinear) {
                tower.frame.origin.y = self.view.frame.height
            } completion: { (_) in
                tower.removeFromSuperview()
                if towerArray.count > 3{
                    towerArray.remove(at: towerArray.count-4)
                }
            }
        }
    }
    
    private func createBack()  {
        back.frame = CGRect(x: self.view.frame.origin.x
                            , y: self.view.frame.origin.y, width: self.view.frame.width, height:
                                self.view.frame.height)
        leftRock.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width/15, height: self.view.frame.height)
        rightRock.frame = CGRect(x: self.view.frame.width - self.view.frame.width/15, y: self.view.frame.origin.y, width: self.view.frame.width/10, height: self.view.frame.height)
        back.image = #imageLiteral(resourceName: "top-view-river-png_99561")
        rightRock.layer.cornerRadius = 5
        rightRock.image = #imageLiteral(resourceName: "unnamed-2")
        view.addSubview(back)
        leftRock.layer.cornerRadius = 5
        leftRock.image = #imageLiteral(resourceName: "unnamed-2")
        view.addSubview(leftRock)
        view.addSubview(rightRock)
    }
    
    private func createHelicopter(){
        self.positionHelicopterX = self.view.frame.width/2 - self.view.frame.width/8
        self.positionHelicopterY = self.view.frame.height/2 + self.view.frame.height/4
        helicopter.frame = CGRect(x: positionHelicopterX, y: positionHelicopterY, width: self.view.frame.width/3.5, height: self.view.frame.height/7.5)
        self.view.addSubview(helicopter)
    }
    
    private func createButtons() {
        buttonLeft.frame = CGRect(x: Double(self.view.frame.width/2) - buttonWidht - buttonWidht/2, y: Double(self.view.frame.height) - buttonHight - buttonHight/2, width: buttonWidht, height: buttonHight)
        buttonRight.frame = CGRect(x: Double(self.view.frame.width/2) + buttonWidht/2, y: Double(self.view.frame.height) - buttonHight - buttonHight/2, width: buttonWidht, height: buttonHight)
        buttonLeft.setTitle("Left", for: .normal)
        buttonRight.setTitle("Right", for: .normal)
        buttonLeft.backgroundColor = .blue
        buttonRight.backgroundColor = .blue
        self.view.addSubview(buttonLeft)
        self.view.addSubview(buttonRight)
        buttonLeft.addTarget(self, action: #selector(leftButton), for: .touchUpInside)
        buttonRight.addTarget(self, action: #selector(rightButton), for: .touchUpInside)
    }

    private func newPositioHelicopter(){
        helicopter.frame = CGRect(x: positionHelicopterX, y: positionHelicopterY, width: self.view.frame.width/3.5, height: self.view.frame.height/7.5)
        self.view.addSubview(helicopter)
        imageViewGif.frame = CGRect(x: positionHelicopterX + self.view.frame.width/25, y: positionHelicopterY +  self.view.frame.height/15, width: self.view.frame.width/4, height: self.view.frame.height/8)
        self.view.addSubview(imageViewGif)
    }
    
    private func createNewBack() {
        newBack.frame = CGRect(x:  0
                               , y:  -self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        newBack.image = #imageLiteral(resourceName: "top-view-river-png_99561")
        print(newBack.frame.origin.y)
        view.addSubview(newBack)
        newleftRock.frame = CGRect(x: self.view.frame.origin.x, y: -self.view.frame.height, width: self.view.frame.width/15, height: self.view.frame.height)
        newrightRock.frame = CGRect(x: self.view.frame.width - self.view.frame.width/15, y: -self.view.frame.height, width: self.view.frame.width/10, height: self.view.frame.height)
        newleftRock.image = #imageLiteral(resourceName: "unnamed-2")
        self.view.addSubview(newleftRock)
        newrightRock.image = #imageLiteral(resourceName: "unnamed-2")
        self.view.addSubview(newrightRock)
        
    }
    
    private func animationForBack(){
        firstBack()
        secondBack()
    }
    
    private func firstBack()  {
        UIView.animate(withDuration: firstBackTime, delay: 0, options: .curveLinear) { [self] in
            newBack.frame.origin.y = self.view.frame.height
            newrightRock.frame.origin.y = self.view.frame.height
            newleftRock.frame.origin.y = self.view.frame.height
            barrier.frame.origin.y = self.view.frame.height
        } completion: { [self] (_) in
            newBack.frame.origin.y = -self.view.frame.height
            newleftRock.frame.origin.y = -self.view.frame.height
            newrightRock.frame.origin.y = -self.view.frame.height
            newPositioHelicopter()
            createButtons()
            firstBack()
        }
    }
    
    private func secondBack() {
        UIView.animate(withDuration: timeBack, delay: 0, options: .curveLinear) { [self] in
            back.frame.origin.y = self.view.frame.height
            rightRock.frame.origin.y = self.view.frame.height
            leftRock.frame.origin.y = self.view.frame.height
            barrier.frame.origin.y = self.view.frame.height
        } completion: { [self] (_) in
            self.timeBack = firstBackTime
            back.frame.origin.y = -self.view.frame.height
            leftRock.frame.origin.y = -self.view.frame.height
            rightRock.frame.origin.y = -self.view.frame.height
            newPositioHelicopter()
            createButtons()
            secondBack()
        }
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [self] (timer) in
            newPositioHelicopter()
            createButtons()
        }
    }
    
    private func addGif(){
        imageViewGif.frame = CGRect(x: positionHelicopterX + self.view.frame.width/25, y: positionHelicopterY +  self.view.frame.height/15, width: self.view.frame.width/4, height: self.view.frame.height/8)
        imageViewGif.alpha = 0.5
        self.view.addSubview(imageViewGif)
    }
    
    private func birdFly(){
        birdTimer = Timer.scheduledTimer(withTimeInterval: birdFlyTime, repeats: true) { [self] (timer) in
            let bird = UIImageView(image: UIImage.gif(name: nameOfBird) )
            bird.frame = CGRect(x: self.view.frame.origin.x, y: CGFloat.random(in:  self.view.frame.origin.y ... self.view.frame.height/4), width: self.view.frame.width/5, height: self.view.frame.height/8)
            self.view.addSubview(bird)
            birdArray.append(bird)
            UIView.animate(withDuration: animationOfBird, delay: 0, options: .curveLinear) {
                bird.frame.origin.y = self.view.frame.height
                bird.frame.origin.x = self.view.frame.width + bird.frame.width
            } completion: { (_) in
                bird.removeFromSuperview()
                if towerArray.count > 5{
                    towerArray.remove(at: towerArray.count-5)
                }
            }
        }
    }
    
    private func createTopBar()  {
        topBar.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height/10)
        topBar.backgroundColor = .blue
        self.view.addSubview(topBar)
        let fuil = UIImageView(image: #imageLiteral(resourceName: "fuel"))
        fuil.frame = CGRect(x:self.topBar.frame.width/2 - self.topBar.frame.width/7, y: self.topBar.frame.height/2.7 , width: self.topBar.frame.width/5, height:  self.topBar.frame.height/1.5)
        self.topBar.addSubview(fuil)
        statusbar.frame = CGRect(x: self.view.frame.origin.x + self.view.frame.width/30, y: self.topBar.frame.height/2, width: self.topBar.frame.width/3, height: self.topBar.frame.height/3)
        statusbar.backgroundColor = .yellow
        self.topBar.addSubview(statusbar)
        distantNumber.frame = CGRect(x: self.topBar.frame.width/1.2, y: self.topBar.frame.height/2, width: self.topBar.frame.width/8, height: self.topBar.frame.height/3)
        distantNumber.backgroundColor = .systemGray
        distantNumber.textColor = .yellow
        self.topBar.addSubview(distantNumber)
        flag.frame = CGRect(x: self.topBar.frame.width/1.8, y: self.topBar.frame.height/2, width: self.topBar.frame.width/4, height: self.topBar.frame.height/3)
        self.topBar.addSubview(flag)
    }
    
    private func changeValueFuel()  {
        self.Timer1 = Timer.scheduledTimer(withTimeInterval: timeOfFuilLavel, repeats: true) { [self] (timer) in
            fuilLavel += 0.1
            statusbar.changeProgress(fuilLavel)
            if fuilLavel >= 1{
                Timer1?.invalidate()
                self.navigationController?.popViewController(animated: true)
                fuilLavel = 0
                statusbar.changeProgress(fuilLavel)
            }
        }
    }
    
    private func move(){
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.02
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data: CMAccelerometerData?, error: Error?) in
                if let acceleration = data?.acceleration {
                    print(acceleration.x)
                    if acceleration.x >= 0 {
                        if self?.helicopter.frame.origin.x ?? CGFloat() + CGFloat(acceleration.x*10) >  self?.leftRock.frame.width ?? CGFloat(){
                            self?.endOfGame()
                            self?.navigationController?.popViewController(animated: true)
                        }else{
                            self?.positionHelicopterX += CGFloat(acceleration.x*10)
                            self?.helicopter.frame.origin.x += CGFloat(acceleration.x*10)
                            self?.imageViewGif.frame.origin.x += CGFloat(acceleration.x*10)
                        }
                    }else{
                        if self?.helicopter.frame.origin.x ?? CGFloat() - CGFloat(acceleration.x*10) <  self?.leftRock.frame.width ?? CGFloat(){
                            self?.endOfGame()
                            self?.navigationController?.popViewController(animated: true)
                        }else{
                            self?.positionHelicopterX -= CGFloat(acceleration.x*10)
                            self?.helicopter.frame.origin.x -= CGFloat(acceleration.x*10)
                            self?.imageViewGif.frame.origin.x -= CGFloat(acceleration.x*10)
                        }
                    }

                }
            }
        }
    }
    
    private func addFuil(){
        fuilTimer = Timer.scheduledTimer(withTimeInterval: timeOfFuil, repeats: true) { [self] (timer) in
            let fuil = UIImageView()
            fuil.frame = CGRect(x:CGFloat.random(in: self.leftRock.frame.width ... self.rightRock.frame.origin.x - self.view.frame.width/7), y:self.view.frame.origin.y - self.view.frame.height/10, width: self.view.frame.width/7, height: self.view.frame.height/10)
            fuil.image = #imageLiteral(resourceName: "fuel")
            self.view.addSubview(fuil)
            fuilArray.append(fuil)
            UIView.animate(withDuration: animationOfFuil, delay: 0, options: .curveLinear) {
                fuil.frame.origin.y = self.view.frame.height
            } completion: { (_) in
                fuil.removeFromSuperview()
                if fuilArray.count > 5{
                    fuilArray.remove(at: towerArray.count-3)
                }
            }
        }
    }
    
    private func replaySound()  {
        soundTimer = Timer.scheduledTimer(withTimeInterval: 9, repeats: true) { [self] (timer) in
            playSound()
        }
    }
    
    private func speedOfGame()  {
        switch speed {
        case 1:
            timeBack *= 0.5
            firstBackTime  *= 0.5
            birdFlyTime  *= 0.5
            timeOfFuil  *= 0.5
            timeOfFuilLavel  *= 0.5
            createTowerTime  *= 0.5
            animationOfTower *= 0.5
            animationOfFuil *= 0.5
            animationOfBird *= 0.5
        case 2:
            timeBack *= 1
            firstBackTime  *= 1
            birdFlyTime  *= 1
            timeOfFuil  *= 1
            timeOfFuilLavel  *= 1
            createTowerTime  *= 1
            animationOfTower *= 1
            animationOfFuil *= 1
            animationOfBird *= 1
        case 3:
            timeBack /= 1.4
            firstBackTime  /= 1.4
            birdFlyTime  /= 1.4
            timeOfFuil  /= 1.4
            timeOfFuilLavel  /= 1.4
            createTowerTime  /= 1.4
            animationOfTower /= 1.4
            animationOfFuil /= 1.4
            animationOfBird /= 1.4
        case 4:
            timeBack /= 1.8
            firstBackTime  /= 1.8
            birdFlyTime  /= 1.8
            timeOfFuil  /= 1.8
            timeOfFuilLavel  /= 1.8
            createTowerTime  /= 1.8
            animationOfTower /= 1.8
            animationOfFuil /= 1.8
            animationOfBird /= 1.8
        case 5:
            timeBack /= 2
            firstBackTime  /= 2
            birdFlyTime  /= 2
            timeOfFuil  /= 2
            timeOfFuilLavel  /= 2
            createTowerTime  /= 2
            animationOfTower /= 2
            animationOfFuil /= 2
            animationOfBird /= 2
        default:
            break
        }
    }
}

