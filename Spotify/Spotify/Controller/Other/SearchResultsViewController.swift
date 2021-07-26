//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Tomashchik Daniil on 25/03/2021.
//

import UIKit
struct SearchSection {
    let title:String
    let result:[SearchResult]
}

protocol SearchResultsViewControllerDelegete:AnyObject {
    func didTapResult(_ result:SearchResult)
}

class SearchResultsViewController: UIViewController {

    weak var delegete:SearchResultsViewControllerDelegete?
    
    private var sections:[SearchSection] = []
    
    private let tableView:UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(SearchResultdefaultTableViewCell.self, forCellReuseIdentifier: SearchResultdefaultTableViewCell.identifier)
        tableView.register(SearchResultUbtiteTableViewCell.self, forCellReuseIdentifier: SearchResultUbtiteTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results:[SearchResult])  {
        let artists = results.filter({
            switch $0{
            case .artist: return true
            
            default:return false
            }
            
        })
        let albums = results.filter({
            switch $0{
            case .album: return true
            default:return false
            }
            
        })
        let tracks = results.filter({
            switch $0{
            case .track: return true
            
            default:return false
            }
            
        })
        let playlists = results.filter({
            switch $0{
            case .playlist: return true
            
            default:return false
            }
            
        })
        self.sections = [
            SearchSection(title: "Songs", result: tracks),
            SearchSection(title: "Artists", result: artists),
            SearchSection(title: "Playlists", result: playlists),
            SearchSection(title: "Albums", result: albums)
        ]
        tableView.reloadData()
        tableView.isHidden =  results.isEmpty
    }


}
extension SearchResultsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  sections[section].result.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].result[indexPath.row]
//        let Acell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        switch result {
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchResultUbtiteTableViewCell.identifier,
                    for: indexPath) as? SearchResultUbtiteTableViewCell else{
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtiteTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "",
                imageURL: URL(string: album.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
            
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchResultdefaultTableViewCell.identifier,
                    for: indexPath) as? SearchResultdefaultTableViewCell else{
                return UITableViewCell()
            }
            let viewModel = SearchResultdefaultTableViewCellViewModel(
                title: artist.name,
                imageURL: URL(string: artist.images?.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchResultUbtiteTableViewCell.identifier,
                    for: indexPath) as? SearchResultUbtiteTableViewCell else{
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtiteTableViewCellViewModel(
                title: track.name,
                subtitle: track.artists.first?.name ?? "",
                imageURL: URL(string: track.album?.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchResultUbtiteTableViewCell.identifier,
                    for: indexPath) as? SearchResultUbtiteTableViewCell else{
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtiteTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name ,
                imageURL: URL(string: playlist.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
        
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].result[indexPath.row]
        delegete?.didTapResult(result)
      
    }
}
