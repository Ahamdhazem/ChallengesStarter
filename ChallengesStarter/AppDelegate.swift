import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let root = MyChallengesViewController(nibName: "MyChallengesViewController", bundle: nil)
        let navigation = UINavigationController(rootViewController: root)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .font: UIFont(name: "Poppins-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor(named: "textPrimary") ?? .label
        ]
        navigation.navigationBar.standardAppearance = appearance
        navigation.navigationBar.scrollEdgeAppearance = appearance
        navigation.navigationBar.tintColor = UIColor(named: "textSecondary")
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
