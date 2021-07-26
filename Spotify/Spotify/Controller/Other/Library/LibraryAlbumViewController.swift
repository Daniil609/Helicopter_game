//
//  LibraryAlbumViewController.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 16/04/2021.
//

import UIKit

class LibraryAlbumViewController: UIViewController {

   
    var albums = [Album]()
    

    private let tableView:UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(SearchResultUbtiteTableViewCell.self, forCellReuseIdentifier: SearchResultUbtiteTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private let noAlbomView = ActionLabelView()
    private var observer:NSObjectProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoAlbumsView()
        fetchData()
        observer = NotificationCenter.default.addObserver(forName: .albumSaveNotification, object: nil, queue: .main, using: {[weak self] (_) in
            self?.fetchData()
        })
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbomView.frame = CGRect(x:( view.width-150)/2, y: (view.hight-150)/2, width: 150, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.hight)
        tableView.frame = view.bounds
    }
    
    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }

    
    private func setUpNoAlbumsView(){
        view.addSubview(noAlbomView)
        noAlbomView.delegete = self
        noAlbomView.configure(with: ActionLabelViewViewModel(text: "You have not any saved albums yet.", actionTitle:  "Brows"))
    }
    
    private func fetchData(){
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbum {[weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI(){
        if albums.isEmpty{
            noAlbomView.isHidden = false
            tableView.isHidden = true
        }else{
            tableView.reloadData()
            noAlbomView.isHidden = true
            tableView.isHidden = false
        }
    }
    

}
extension LibraryAlbumViewController:ActionLabelViewDelegete{
    func actionLabelViewTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}
extension LibraryAlbumViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultUbtiteTableViewCell.identifier,for: indexPath) as? SearchResultUbtiteTableViewCell else{
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultSubtiteTableViewCellViewModel(title: album.name, subtitle:album.artists.first?.name ?? "-" , imageURL:URL(string: album.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album = albums[indexPath.row]
//        guard selectionHemdler == nil else {
//            selectionHemdler?(playlist)
//            dismiss(animated: true, completion: nil)
//            return
//        }
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
       
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    


}
