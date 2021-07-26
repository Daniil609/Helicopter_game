import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = HomeViewController()
        let secondVC = SearchViewController()
        let thirdVC = LibraryViewController()
        
        firstVC.title = "Browse"
        secondVC.title = "Search"
        thirdVC.title = "Library"
        
        firstVC.navigationItem.largeTitleDisplayMode = .always
        secondVC.navigationItem.largeTitleDisplayMode = .always
        thirdVC.navigationItem.largeTitleDisplayMode = .always
       
        let firstNavigationController = UINavigationController(rootViewController: firstVC)
        let secondNavigationController = UINavigationController(rootViewController: secondVC)
        let thirdNavigationController = UINavigationController(rootViewController: thirdVC)
        
        firstNavigationController.navigationBar.tintColor = .label
        secondNavigationController.navigationBar.tintColor = .label
        thirdNavigationController.navigationBar.tintColor = .label
        
        firstNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        secondNavigationController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        thirdNavigationController.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1)
        
        firstNavigationController.navigationBar.prefersLargeTitles = true
        secondNavigationController.navigationBar.prefersLargeTitles = true
        thirdNavigationController.navigationBar.prefersLargeTitles = true
        
        setViewControllers([firstNavigationController,secondNavigationController,thirdNavigationController], animated: false)
    }
}
