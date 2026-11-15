import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Configure audio session immediately on launch
        AudioSessionManager.shared.configureAudioSession()

        // Setup main window and root view controller
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = AppConfig.chassisBackground
        window.rootViewController = WebViewController()
        window.makeKeyAndVisible()
        self.window = window

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Re-affirm audio session in case other apps interrupted it
        AudioSessionManager.shared.configureAudioSession()
    }

    // MARK: - UISceneSession Lifecycle (iOS 13+)
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}
