

import UIKit
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

    
}

