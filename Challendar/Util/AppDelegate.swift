import UIKit
import UserNotifications
import WidgetKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ValueTransformer.setValueTransformer(DictionaryTransformer(), forName: NSValueTransformerName("DictionaryTransformer"))
        
        ValueTransformer.setValueTransformer(IntArrayTransformer(), forName: NSValueTransformerName("IntArrayTransformer"))
        
        ValueTransformer.setValueTransformer(StringArrayTransformer(), forName: NSValueTransformerName("StringArrayTransformer"))
        
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
        
        // 앱 실행 시 사용자에게 알림 허용 권한 -> CoreDataManager
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in}
        )
        
        //        // Fetch todos on app launch
        //        CoreDataManager.shared.triggerSync()
        //
        //        // 주기적인 동기화 설정
        //        startSyncTimer()
        
        // Fetch todos on app launch
        
        CloudKitHelper.shared.checkSchemaUpdateStatus { isSchemaUpdated in
            if !isSchemaUpdated {
                CoreDataManager.shared.deleteAllTodos()
                CoreDataManager.shared.saveContext()
                CloudKitHelper.shared.markSchemaAsUpdated { success in
                    if success {
                        print("Schema marked as updated.")
                    } else {
                        print("Failed to mark schema as updated.")
                    }
                }
            } else {
                CoreDataManager.shared.triggerSync()
            }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    private func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    }
    
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Foreground 알림 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
    }
    
    // Background, Foreground 알림에 대해 사용자가 반응했을 때 실행
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
