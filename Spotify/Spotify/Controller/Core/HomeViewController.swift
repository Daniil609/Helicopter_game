import UIKit

enum BrowseSectionType {
    case newReleases(viewModels:[NewReleasesCellViewModel])
    case featurePlylist(viewModels:[FeaturePlaylistCellViewModel])
    case recomendedTracks(viewModels:[RecomendedTrackCellViewModel])
    
    var title:String{
        switch self {
        case .newReleases:
            return "New Release Album"
        case .featurePlylist:
            return "Featured Playlist"
        case .recomendedTracks:
            return "Recomended"
        }
    }
}

class HomeViewController: UIViewController  {
    
    private var newAlbum:[Album] = []
    private var playList:[Playlist] = []
    private var tracks:[AudioTrack] = []
    
    private let spiner:UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView()
        spiner.tintColor = .label
        spiner.hidesWhenStopped = true
        return spiner
    }()
    
    private var collecyioView:UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return createSectionLayout(section: sectionIndex)
        })
    
    private var sections = [BrowseSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        configureCollectioView()
        view.addSubview(spiner)
        fetchData()
        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collecyioView.frame = view.bounds
    }
    
    private func addLongTapGesture(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        collecyioView.isUserInteractionEnabled = true
        collecyioView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress(_ gesture:UILongPressGestureRecognizer){
        guard gesture.state == .began else {
            return
        }
        let touchPoint = gesture.location(in: collecyioView)
        
        guard let indexPath = collecyioView.indexPathForItem(at: touchPoint),
              indexPath.section == 2 else {
            return
        }
        let modul = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(title: modul.name, message: "Would you like to add this to a playlist", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: {[weak self] _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistViewController()
                vc.selectionHemdler = {playlist in
                    APICaller.shared.addTrackTaPlaylist(track: modul, playlist: playlist) { success in
                        print("add to playlist\(success)")
                    }
                }
                vc.title = "Select Playlist"
                self?.present(UINavigationController(rootViewController: vc), animated: true)
            }
           
        }))
        present(actionSheet, animated: true)
        
    }
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        vc.title = "settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureCollectioView(){
        view.addSubview(collecyioView)
        collecyioView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collecyioView.register(NewReleseCollectionViewCell.self,
                               forCellWithReuseIdentifier: NewReleseCollectionViewCell.identifier)
        collecyioView.register(FeaturePlaylistCollectionViewCell.self,
                               forCellWithReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier)
        collecyioView.register(RecomendedTrackCollectionViewCell.self,
                               forCellWithReuseIdentifier: RecomendedTrackCollectionViewCell.identifier)
        collecyioView.register(TitleHeaderCollectionReusableView.self,
                               forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                               withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collecyioView.dataSource = self
        collecyioView.delegate = self
        collecyioView.backgroundColor = .systemBackground
        
    }
    
    
    private func fetchData(){
        let grup = DispatchGroup()
        grup.enter()
        grup.enter()
        grup.enter()
        
        var newReleses:NewReleasesRespons?
        var featurePlylist:FeaturePlaylistResponse?
        var recomdations:RecomendationsResponse?
        
        //New Release
        APICaller.shared.getNewReleases { result in
            defer{
                grup.leave()
            }
            switch result{
            case .success(let model):
                newReleses = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Feature Playlist
        APICaller.shared.getFeaturePlayList{ result in
            defer{
                grup.leave()
            }
            switch result{
            case .success(let model):
                featurePlylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //Recomended Track
        APICaller.shared.getRecomendationsGenres { result in
            switch result{
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                APICaller.shared.getRecomendations(genres: seeds) { recomendedResults in
                    defer{
                        grup.leave()
                    }
                    switch recomendedResults{
                    case .success(let model):
                        recomdations = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        grup.notify(queue: .main){
            guard let newAlbums = newReleses?.albums.items,
                  let playList = featurePlylist?.playlists.items,
                  let tracks = recomdations?.tracks else{
                return
            }
            self.configureModels(newAlbum: newAlbums, playlist: playList, tracks: tracks)
        }
    }
    
    private func configureModels(newAlbum:[Album],playlist:[Playlist], tracks:[AudioTrack]){
        self.newAlbum = newAlbum
        self.playList = playlist
        self.tracks = tracks
        
        sections.append(.newReleases(viewModels: newAlbum.compactMap({ return NewReleasesCellViewModel(
            name: $0.name,
            artworkURl: URL(string: $0.images.first?.url ?? ""),
            numberOfTracks: $0.total_tracks,
            artistName: $0.artists.first?.name ?? "-"
        )
        })))
        
        sections.append(.featurePlylist(viewModels: playlist.compactMap({ return  FeaturePlaylistCellViewModel (
            name: $0.name,
            artWorkURL: URL(string: $0.images.first?.url ?? ""),
            creatorName: $0.owner.display_name
        )
        })))
        
        sections.append(.recomendedTracks(viewModels: tracks.compactMap({ return RecomendedTrackCellViewModel(
            name: $0.name,
            artistName: $0.artists.first?.name ?? "-",
            artworkURL:  URL(string: $0.album?.images.first?.url ?? "")
        )
        })))
        collecyioView.reloadData()
    }
}
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featurePlylist(let viewModels):
            return viewModels.count
        case .recomendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleseCollectionViewCell.identifier, for: indexPath) as? NewReleseCollectionViewCell else{
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configre(with: viewModel)
            return cell
        case .featurePlylist(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturePlaylistCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.configre(with: viewModels[indexPath.row])
            return cell
            
        case .recomendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendedTrackCollectionViewCell.identifier, for: indexPath) as? RecomendedTrackCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.configre(with: viewModels[indexPath.row])
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section{
        case.featurePlylist:
            let playlist = playList[indexPath.row]
            var vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case.newReleases:
            let album = newAlbum[indexPath.row]
            var vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case.recomendedTracks:
            let track = tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
    
    static func createSectionLayout(section:Int)->NSCollectionLayoutSection{
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(
                layoutSize:  NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let vertivalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 3
            )
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)
                ),
                subitem: vertivalGroup,
                count: 1
            )
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 1:
            let item = NSCollectionLayoutItem(
                layoutSize:  NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let vertivalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: item,
                count: 2
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: vertivalGroup,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 2:
            let item = NSCollectionLayoutItem(
                layoutSize:  NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)
                ),
                subitem: item,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            let item = NSCollectionLayoutItem(
                layoutSize:  NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1
            )
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
}
