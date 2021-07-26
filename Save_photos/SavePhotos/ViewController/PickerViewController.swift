

import UIKit
enum Keys:String {
    case KeyForImage = "key"
    
}
class PickerViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - let
    let imagePicker = UIImagePickerController()
    
    //MARK: - var
    var imageName:String?
    var resultArrayNew = [UIImage]()
    var like:Bool?
    var comment:String?
    var indexOfPhoto:Int?
    
    //MARK: - vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addPhotos()
    }
    
    //MARK: - IBAction
    @IBAction func addPhoto(_ sender: UIButton) {
        createAlert()
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton)  {
        print(sender.tag)
        print("Hello Edit Button")
        if sender.tag == resultArrayNew.count-1{
            createAlert()
        }else{
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "PictureViewController") as? PictureViewController else{
                return
            }
            controller.index = sender.tag
            controller.modalTransitionStyle = .flipHorizontal
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    //MARK: - func
    private func addPhotos()  {
        let array = Manager.shared.loadArrayFromMemory()
        for element in array{
            resultArrayNew.append(Manager.shared.loadImage(fileName: element.imageName ?? "") ?? UIImage() )
        }
        resultArrayNew.append(UIImage(named: "editButton") ?? UIImage())
    }
    
    private func createAlert() {
    let alert = UIAlertController(title: nil, message: "Choose your source", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { (result : UIAlertAction) -> Void in
          print("Camera selected")
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Photo library", style: .default) { (result : UIAlertAction) -> Void in
          print("Photo selected")
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.allowsEditing = false
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func performImagePicker() {
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.allowsEditing = false
    }
}
extension PickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageName = Manager.shared.saveImage(image: pickedImage)
            Manager.shared.save(imageName: imageName, like: like, comment: comment)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
extension PickerViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultArrayNew.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.addImge(object: resultArrayNew[indexPath.item])
        cell.layer.cornerRadius = 5
        let editButton = UIButton(frame: CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y, width: (self.view.frame.width-10)/2,height: (self.view.frame.width-10)/2))
        editButton.tag = indexPath.row
       
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.addSubview(editButton)
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let side:CGFloat = (self.view.frame.width-10)/2
        return CGSize(width: side, height: side)
    }
}




