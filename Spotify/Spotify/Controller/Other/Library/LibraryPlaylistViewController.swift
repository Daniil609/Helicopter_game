//
//  LibraryPlaylistViewController.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 16/04/2021.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {

    var playlists = [Playlist]()
    public var selectionHemdler:((Playlist)->Void)?

    private let tableView:UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(SearchResultUbtiteTableViewCell.self, forCellReuseIdentifier: SearchResultUbtiteTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private let noPlaylistView = ActionLabelView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoPlaylistView()
        fetchData()
        
        if selectionHemdler != nil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistView.center = view.center
        tableView.frame = view.bounds
    }
    
    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpNoPlaylistView(){
        view.addSubview(noPlaylistView)
        noPlaylistView.delegete = self
        noPlaylistView.configure(with: ActionLabelViewViewModel(text: "You dont't have any playlists yet.", actionTitle:  "Create"))
    }
    
    private func fetchData(){
        APICaller.shared.getCurrentUserPraylist {[weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let playlist):
                    self?.playlists = playlist
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI(){
        if playlists.isEmpty{
            noPlaylistView.isHidden = false
            tableView.isHidden = true
        }else{
            tableView.reloadData()
            noPlaylistView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    public func showCreatePlaylistAlert(){
        let alert = UIAlertController(title: "New Playlist", message: "Enter playlist name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: {_ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else{
                return
            }
            
            APICaller.shared.createPlaylist(with: text) {[weak self] success in
                if success{
                    self?.fetchData()
                }else{
                    print("faild to create playlist")
                }
            }
        }))
        present(alert, animated: true)
    }
}
extension LibraryPlaylistViewController:ActionLabelViewDelegete{
    func actionLabelViewTapButton(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()
    }
}
extension LibraryPlaylistViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultUbtiteTableViewCell.identifier,for: indexPath) as? SearchResultUbtiteTableViewCell else{
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtiteTableViewCellViewModel(title: playlist.name, subtitle: playlist.owner.display_name, imageURL:URL(string: playlist.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        guard selectionHemdler == nil else {
            selectionHemdler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
