import UIKit
import WidgetKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var syncTimer: Timer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 15, *) {
            // MARK: Navigation bar appearance
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.shadowColor = .clear
            navigationBarAppearance.shadowImage = UIImage()
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
            navigationBarAppearance.backgroundColor = UIColor.secondary900
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        
        // Fetch todos on app launch
        CoreDataManager.shared.triggerSync()
        
        // 주기적인 동기화 설정
        startSyncTimer()

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // 앱이 포그라운드로 돌아올 때 동기화 트리거
        CoreDataManager.shared.triggerSync()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // 타이머 중지
        stopSyncTimer()
        WidgetCenter.shared.reloadTimelines(ofKind: "ChallendarWidget")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // 타이머 중지
        stopSyncTimer()
        WidgetCenter.shared.reloadTimelines(ofKind: "ChallendarWidget")
    }
    
    private func startSyncTimer() {
        syncTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            CoreDataManager.shared.triggerSync()
        }
    }
    
    private func stopSyncTimer() {
        syncTimer?.invalidate()
        syncTimer = nil
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // Core Data stack and saving context are now handled by CoreDataManager

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
