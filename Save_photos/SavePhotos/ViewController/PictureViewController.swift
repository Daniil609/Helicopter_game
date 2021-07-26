
import UIKit
class PictureViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageViewForPhoto: UIImageView!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!

    //MARK: - var
    var index = 0
    var indexForComment = 0
    var indexForLike = 0
    var positionX:CGFloat?
    var positionY:CGFloat?
    var photoWidth:CGFloat?
    var photoHight:CGFloat?
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var blurEffectView:UIVisualEffectView?
    var imageViewArrey = [UIImageView?]()
    var imageArray = [UIImage?]()
    var caunt:Int?
    var imagefromMemory:UIImage?
    var backOfImage = UIView()
    var imageview:UIImageView?
    var xPosiotAnimatioRight:CGFloat?
    
    //MARK: - vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        positionX = self.photoView.frame.width/8
        positionY = self.photoView.frame.origin.y*1.3
        photoWidth = self.photoView.frame.width/1.3
        photoHight = self.photoView.frame.height/1.3
        xPosiotAnimatioRight = self.photoView.frame.width/8
        
        backOfImage.frame = CGRect(origin: photoView.center, size: CGSize(width: 10.0, height: 10.0))
        backOfImage.backgroundColor = .blue
        backOfImage.alpha = 0.5
        scrollView.addSubview(backOfImage )
    
        checkPhotoVolue()
        registerForKeyboardNotifications()
        
        detectedLike()
        detectedComments()
        caunt = Manager.shared.imageArray.count
        
        imagefromMemory = Manager.shared.loadImage(fileName: Manager.shared.imageArray[index].imageName ?? "")
        imageview = UIImageView(image: imagefromMemory)
        imageViewArrey.append(imageview)
        createFirstImage()

        let recognizertab = UITapGestureRecognizer(target: self, action: #selector(self.tapdetected(_:)))
        self.photoView?.addGestureRecognizer(recognizertab)
        
        let recognizerleft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDetectedleft(_:)))
        recognizerleft.direction = .left
        self.scrollView?.addGestureRecognizer(recognizerleft)
        
        let recognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDetectedRighth(_:)))
        recognizerRight.direction = .right
        self.scrollView?.addGestureRecognizer(recognizerRight)
        
    }
    
    //MARK: - IBAction
    @IBAction func swipeDetectedleft(_ sender: UISwipeGestureRecognizer) {
        moveLeft()
    }
    
    @IBAction func swipeDetectedRighth(_ sender: UISwipeGestureRecognizer) {
        moveRight()
    }
    
    @IBAction func BackButton(_ sender: UIButton) {
        Manager.shared.saveChangies()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapdetectedblure(_ sender: UITapGestureRecognizer) {
        photoWidth = self.photoView.frame.width/1.3
        photoHight = self.photoView.frame.height/1.3
        positionX = self.photoView.frame.width/8
        positionY = self.photoView.frame.origin.y*1.3
        xPosiotAnimatioRight = self.photoView.frame.width/8
        UIView.animate(withDuration: 1) { [self] in
            self.backOfImage.frame =  CGRect(x: positionX ?? CGFloat(), y: positionY ??  CGFloat(), width: self.photoView.frame.width/100, height: self.photoView.frame.height/100)
            self.imageview?.frame = CGRect(x: positionX ??  CGFloat(), y: positionY ??  CGFloat() ,width: self.photoView.frame.width/1.3, height: self.photoView.frame.height/1.3)
        }
    }
    @IBAction func tapdetected(_ sender: UITapGestureRecognizer) {
        photoWidth = self.photoView.frame.width
        photoHight = self.photoView.frame.height
        positionY = self.topView.frame.origin.y
        positionX = self.topView.frame.origin.x
        xPosiotAnimatioRight = self.topView.frame.origin.x
        UIView.animate(withDuration: 1) {
            self.backOfImage.frame = self.view.bounds
            self.backOfImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.imageview?.frame = self.photoView.bounds
            self.imageview?.frame.origin.y = self.topView.frame.height
        } completion: { (_) in
            let recognizertab1 = UITapGestureRecognizer(target: self, action: #selector(self.tapdetectedblure(_:)))
            self.backOfImage.addGestureRecognizer(recognizertab1)
            let recognizerleft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDetectedleft(_:)))
            recognizerleft.direction = .left
            self.scrollView?.addGestureRecognizer(recognizerleft)
            
            let recognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDetectedRighth(_:)))
            recognizerRight.direction = .right
            self.scrollView?.addGestureRecognizer(recognizerRight)
        }
    }
    
    @IBAction func makeLike(_ sender: UIButton) {
        if Manager.shared.imageArray[index].like ?? false{
            likeImage.image = #imageLiteral(resourceName: "dislike")
            Manager.shared.imageArray[index].like = false
        }else{
            likeImage.image = #imageLiteral(resourceName: "like")
            Manager.shared.imageArray[index].like = true
        }
        Manager.shared.saveChangies()
    }
    
    @IBAction func rightButton(_ sender: UIButton) {
        moveRight()
    }
    
    @IBAction func leftButton(_ sender: UIButton) {
       moveLeft()
    }
    
    @IBAction private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomViewConstraint.constant = 0
        } else {
            bottomViewConstraint.constant = keyboardScreenEndFrame.height + 10
        }
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - func
    private func checkPhotoVolue() {
        if Manager.shared.imageArray.isEmpty{
            let alert = UIAlertController(title: "No photos, please choise", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { (result : UIAlertAction) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func detectedComments()  {
        let element = Manager.shared.imageArray[index].comment ?? ""
        commentField.text = element
    }
    
    private func detectedLike() {
        if Manager.shared.imageArray[index].like ?? false{
            likeImage.image = #imageLiteral(resourceName: "like")
        }else{
            likeImage.image = #imageLiteral(resourceName: "dislike")
        }
    }
    
    private func moveRight()  {
        if index + 1 >= Manager.shared.imageArray.count{
            index = 0
            imagefromMemory = Manager.shared.loadImage(fileName: Manager.shared.imageArray[index].imageName ?? "")
            imageview = UIImageView(image: imagefromMemory)
            createImageAdd()
            imageViewArrey.append(imageview)
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeLinear) { [self] in
                self.imageview?.frame.origin.x = xPosiotAnimatioRight ?? CGFloat()
            } completion: { [self] (_) in
                detectedComments()
                detectedLike()
                imageViewArrey.removeAll()
            }
        }else  {
            index += 1
            imagefromMemory = Manager.shared.loadImage(fileName: Manager.shared.imageArray[index].imageName ?? "")
            imageview = UIImageView(image: imagefromMemory)
            createImageAdd()
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeLinear) { [self] in
                self.imageview?.frame.origin.x = xPosiotAnimatioRight ?? CGFloat()
            } completion: { [self] (_) in
                commentField.text = ""
                detectedComments()
                imageViewArrey.removeAll()
                detectedLike()
            }
        }
    }
    
    private func moveLeft()  {
        if !imageViewArrey.isEmpty{
            delete()
        }
        if index - 1 < 0{
            imagefromMemory = Manager.shared.loadImage(fileName: Manager.shared.imageArray[Manager.shared.imageArray.count - 1].imageName ?? "")
            imageview = UIImageView(image: imagefromMemory)
            createImage()
            imagefromMemory = Manager.shared.loadImage(fileName: Manager.shared.imageArray[index].imageName ?? "")
            imageview = UIImageView(image: imagefromMemory)
            createImageDelete()
            UIView.animate(withDuration: 1) { [self] in
                imageview?.frame.origin.x = -self.view.frame.width
            } completion: { [self] (_) in
                index =  Manager.shared.imageArray.count - 1
                commentField.text = ""
                detectedComments()
                detectedLike()
                imageview?.removeFromSuperview()
                imagefromMemory = Manager.shared.loadImage(fileName: Manager.shared.imageArray[index].imageName ?? "")
                imageview = UIImageView(image: imagefromMemory)
                createImage()
            }
        }else {
            imagefromMemory = Manager.shared.loadImage(fileName: Manager.shared.imageArray[index - 1].imageName ?? "")
            imageview = UIImageView(image: imagefromMemory)
            createImage()
            imagefromMemory = Manager.shared.loadImage(fileName: Manager.shared.imageArray[index].imageName ?? "")
            imageview = UIImageView(image: imagefromMemory)
            createImageDelete()
            UIView.animate(withDuration: 1) { [self] in
                imageview?.frame.origin.x = -self.view.frame.width
            } completion: { [self] (_) in
                index -= 1
                imageview?.removeFromSuperview()
                commentField.text = ""
                detectedComments()
                detectedLike()
                imagefromMemory = Manager.shared.loadImage(fileName: Manager.shared.imageArray[index].imageName ?? "")
                imageview = UIImageView(image: imagefromMemory)
                createImage()
            }
        }
    }
    
    private func createFirstImage()  {
        imageview?.frame = CGRect(x: positionX ??  CGFloat(), y: positionY ??  CGFloat() ,width: photoWidth ?? CGFloat(), height: photoHight ?? CGFloat())
        photoView.dropShadow()
        imageViewArrey.append(imageview)
        self.scrollView.addSubview(imageview ?? self.view)
    }
    
    private func createImageAdd()  {
        let positionX = self.photoView.frame.width
        imageview?.frame = CGRect(x:positionX, y: positionY ??  CGFloat(), width: photoWidth ?? CGFloat(), height: photoHight ?? CGFloat())
        photoView.dropShadow()
        self.scrollView.addSubview(imageview ?? self.view )
    }
    
    private func createImage()  {
        imageview?.frame = CGRect(x: positionX ??  CGFloat(), y: positionY ??  CGFloat(),width: photoWidth ?? CGFloat(), height: photoHight ?? CGFloat())
        photoView.dropShadow()
        self.scrollView.addSubview(imageview ?? self.view)
    }
    
    private func createImageDelete()  {
        imageview?.frame = CGRect(x:positionX ??  CGFloat(), y: positionY ??  CGFloat(),width: photoWidth ?? CGFloat(), height: photoHight ?? CGFloat())
        photoView.dropShadow()
        self.scrollView.addSubview(imageview ?? self.view)
    }
    
    private func styleOfImage()  {
        for element in imageViewArrey{
            element?.dropShadow()
        }
    }
    
    private func delete(){
        for element in imageViewArrey{
            element?.removeFromSuperview()
        }
        imageViewArrey.removeAll()
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
extension PictureViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if ((Manager.shared.imageArray[index].comment?.isEmpty) != nil){
            Manager.shared.imageArray[index].comment? = textField.text ?? ""
        }
        Manager.shared.saveChangies()
        return true
    }
}




