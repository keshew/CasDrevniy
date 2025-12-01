import SwiftUI

@main
struct CasDrevniyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        let stats = UserDefaultsManager.shared
        let key = "didAddInitialCoins"
        if !UserDefaults.standard.bool(forKey: key) {
            stats.addCoins(5000)
            UserDefaults.standard.set(true, forKey: key)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MenuView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.landscape

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
