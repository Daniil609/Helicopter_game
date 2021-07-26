import UIKit

class WelcomeViewController: UIViewController {

    private let singInButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sing in with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

       title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(singInButton)
        singInButton.addTarget(self, action: #selector(didTapSingIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        singInButton.frame = CGRect(x: 20,
                                    y: view.hight - 50 - view.safeAreaInsets.bottom ,
                                    width: view.width - 40 ,
                                    height: 50)
    }
    
    @objc func didTapSingIn(){
        let vc = AuthViewController()
        vc.copmlitionHandler = {[weak self] success in
            DispatchQueue.main.async {
                self?.handlerSingnIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handlerSingnIn(success:Bool){
        guard  success else {
            let alert = UIAlertController(title: "OOps",
                                           message: "Something went wrong when signing in.",
                                           preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }

}
