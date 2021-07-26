
import UIKit

class RecordsViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var table: UITableView!

    //MARK: - var
    var recordsArray = [Records]()
    
    //MARK: - vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        loadArray()
        recordsArray.sort(by: {$1.resultOfGame ?? 0 < $0.resultOfGame ?? 0})
    }
    //MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - func
    func loadArray()  {
        if let resultArray =  UserDefaults.standard.value([Records].self, forKey: Keys.KeyForResults.rawValue) {
            recordsArray = resultArray
           

        }else{return}
    }
   

}
extension RecordsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.fillingTable(object: recordsArray[indexPath.row], index: indexPath.row)
        
       return cell
    }
    
    
}
