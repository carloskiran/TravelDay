//
//  AppDelegate.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 26/03/23.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit
import CoreLocation
//import LocationPushService
import UserNotifications
import FirebaseAuth
import FirebaseMessaging
import Mixpanel


@main
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate, MessagingDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    var window: UIWindow?
    var tabBarController = ESTabBarController()
    let locationManager = CLLocationManager()
    let kLogsFile = "LocationLogs"
    let kLogsDirectory = "LocationData"
    let createTravelViewModel = CreateNewTravelViewModel()
    var deviceToken = String()
    var locationToken = String()
    var registerAPIToken = updateToken()
    var orientationLock:UIInterfaceOrientationMask = [.portrait]
    var isAppBackground:Bool = false
    weak var appRefreshDelegate:RefreshAppDelegate?
    
    // MARK: - Did Finish Launching With Options
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 4.0)
        self.registerNotifications(application: application)
        enableMixPanel()
        setupMainController()
        setupNetworkManager()
        Languagehandler.shared.saveLanguage(languageName: .english)
        IQKeyboardManager.shared.enable = true
        AppCenter.start(withAppSecret: "42f2f68a-3554-430a-aebf-639185ef10da", services:[
          Crashes.self
        ])
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        if (UserDefaultModule.shared.value(forKey: "firstTimeDownload")) == nil {
            UserDefaultModule.shared.set("true", forKey: "firstTimeDownload")
        }
        if UserDefaultModule.shared.getAccessToken() != "" {
            LocationManager.shared.setupLocationManager()
        }
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.startUpdatingLocation()
        // Override point for customization after application launch.
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startMonitoringSignificantLocationChanges()
        // Start monitoring location pushes
//        locationManager.startMonitoringLocationPushes { token, error in
//            if let error = error {
//                print("errors \(error.localizedDescription)")
//            }
//            guard let tokenData = token else {
//                return
//            }
//            let retrived = tokenData.map { String(format: "%02.2hhx", $0) }.joined()
//            // Send the APNs token to your server
//            print(retrived)
////            self.sendTokenToServer(tokenData)
//            if  let userID = UserDefaultModule.shared.getUserID(), userID != "" {
//                DispatchQueue.main.async {
//                    self.registerAPIToken.RegisterTokenAPICall(userId: userID, loctionToken: self.locationToken, isLocationToken: true) { response in
//                        print(response)
//                    } onFailure: { error in
//                        print(error)
//                    }
//                }
//            }
//        }
        //Dark theme
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let userdefault = UserDefaults.standard
//        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
//        appDelegate.window!.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        return true
    }
    
    private func enableMixPanel() {
        Mixpanel.initialize(token: ServerEndpoint.mix_panel_token, trackAutomaticEvents: true)
        Mixpanel.mainInstance().loggingEnabled = false
    }
    
    
    
    // MARK:Move to Tab bar view at selected index
    func moveToTabbarViaIndex(intIndex : Int) {
        tabBarController = ESTabBarController()
        tabBarController.delegate = self
        tabBarController.tabBar.clipsToBounds = true
        tabBarController.tabBar.backgroundImage = UIImage()
//            let bgView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "light-btm-menu-bg 1"))
//        bgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 85)
//        bgView.contentMode = .scaleToFill
//        tabBarController.tabBar.addSubview(bgView)
//        let image = UIImage(named: "light-btm-menu-bg 1")
//        if let image = image {
//        var resizeImage: UIImage?
//        let size = CGSize(width: UIScreen.main.bounds.size.width , height: 85)
//        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//         UIGraphicsBeginImageContextWithOptions(size, false, 0)
//       resizeImage = UIGraphicsGetImageFromCurrentImageContext()
//       UIGraphicsEndImageContext()
//        tabBarController.tabBar.backgroundImage = resizeImage?.withRenderingMode(.alwaysOriginal)
//       }
        let v1 = DashBoardViewController.loadFromNib()
        let v2 = DashBoardViewController.loadFromNib()
        let v3 = CreateNewTravelViewController.loadFromNib()
        let v4 = MyProfileViewController.loadFromNib()
        let v5 = SettingsViewController.loadFromNib()
        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Home", image: UIImage(named: "home-icon-normal"), selectedImage: UIImage(named: "home-icon-normal"))
        v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Favor", image: UIImage(named: "Travel-history-icon"), selectedImage: UIImage(named: "Travel-history-icon"))
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "Add-new-icon"), selectedImage: UIImage(named: "Add-new-icon"))
        v4.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Dashboard", image: UIImage(named: "Profile-icon"), selectedImage: UIImage(named: "Profile-icon"))
        v5.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Me", image: UIImage(named: "settings-icon"), selectedImage: UIImage(named: "settings-icon"))
        tabBarController.viewControllers = [v1,v4,v5] // [v1, v2 , v3, v4, v5]
       // if(intIndex == 0) {
            tabBarController.selectedViewController = v1
       // }
//        else if(intIndex == 1) {
//            tabBarController.selectedViewController = v2
//        } else if(intIndex == 2) {
//            tabBarController.selectedViewController = v3
//        } else if(intIndex == 3) {
//            tabBarController.selectedViewController = v4
//        } else if(intIndex == 4) {
//            tabBarController.selectedViewController = v5
//        }
        let landingTabbar = LandingTabBarController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let nav1 = UINavigationController()
//        nav1.isNavigationBarHidden = true
//        nav1.viewControllers = [tabBarController]
        self.window!.rootViewController = landingTabbar
        self.window?.makeKeyAndVisible()
    
    }
    func logoutSession() {
        UserDefaultModule.shared.setAccessToken(token: "")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "profilepic")
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removePersistentDomain(forName: "group.com.obs.travelpro")
        UserDefaultModule.shared.set(nil, forKey: "noTravelRecordUser")
        UserDefaultModule.shared.set(nil, forKey: "tax_start_date")
        UserDefaultModule.shared.set(nil, forKey: "tax_end_date")
        UserDefaultModule.shared.set(nil, forKey: "max_stay_count")
        UserDefaultModule.shared.set(nil, forKey: "definition_of_day")

//            userDefaults.set("", forKey: "accessToken")
//            userDefaults.removeObject(forKey: "user_id")
//        }
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TravelPro")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Private methods
    
    func topViewController(
        base: UIViewController? = (UIApplication.shared.delegate as? AppDelegate)!.window?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    /// SetupMainController
     func setupMainController() {
        if UserDefaultModule.shared.getAccessToken() == "" {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let welcomePage = WelcomeLandingViewController.loadFromNib()
            welcomePage.hidesBottomBarWhenPushed = true
//            let welcomePage = CreatePasswordViewController.loadFromNib()
            let navigationController = UINavigationController.init(rootViewController: welcomePage)
            navigationController.navigationBar.isHidden = true
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
            
        } else {
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.moveToTabbarViaIndex(intIndex: 0)
        }
        

    }
    
    func setLoginViewcontroller() {
           self.window = UIWindow(frame: UIScreen.main.bounds)
           let welcomePage = LoginViewController.loadFromNib()
           let navigationController = UINavigationController.init(rootViewController: welcomePage)
           navigationController.navigationBar.isHidden = true
           self.window?.rootViewController = navigationController
           self.window?.makeKeyAndVisible()
        

   }
    func welcomeLandingpage() {
           self.window = UIWindow(frame: UIScreen.main.bounds)
           let welcomePage = WelcomeLandingViewController.loadFromNib()
           let navigationController = UINavigationController.init(rootViewController: welcomePage)
           navigationController.navigationBar.isHidden = true
           self.window?.rootViewController = navigationController
           self.window?.makeKeyAndVisible()
        

   }
    
    /// SetupNetworkManager
    private func setupNetworkManager() {
        if let baseURL = URL(string: ServerAPIURL.ttd_ServiceUrl) {
            let config = NetworkManagerConfiguration(baseURL: baseURL)
            TTDNetworkManager.shared(with: config)
        }
    }
    
//    func createRegion(location: CLLocation?) {
//        guard let location = location else {
//            print("Problem with location in creating region")
//            return
//        }
//        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//
//            let coordinate = CLLocationCoordinate2DMake((location.coordinate.latitude), (location.coordinate.longitude))
//            let regionRadius = 50.0
//
//            let region = CLCircularRegion(center: CLLocationCoordinate2D(
//                latitude: coordinate.latitude,
//                longitude: coordinate.longitude),
//                                          radius: regionRadius,
//                                          identifier: "aabb")
//
//            //region.notifyOnEntry = true
//            region.notifyOnExit = true
//
////            scheduleLocalNotification(alert: "Region Created \(location.coordinate) with \(location.horizontalAccuracy)")
//            print("Region Created \(location.coordinate) with \(location.horizontalAccuracy)")
////            self.locationManager.stopUpdatingLocation()
//            print("stopUpdatingLocation")
//            self.locationManager.startMonitoring(for: region)
//            print("startMonitoring")
//        }
//        else {
//            print("System can't track regions")
//        }
//    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
//        FTVMixPanelAnalytics(action: .live, state: .info, data: MixPanelData(liveState: .appdelegate_app_resign_active))
        TravelTaxMixPanelAnalytics(action: .appdelegate, state: .info, data: MixPanelData(message:"applicationWillResignActive" ))
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        TravelTaxMixPanelAnalytics(action: .appdelegate, state: .info, data: MixPanelData(message: "applicationDidEnterBackground"))
        if UserDefaultModule.shared.getAccessToken() != "" {
            isAppBackground = true
        }
        Mixpanel.mainInstance().flush()
        NetworkMonitor().stopMonitoring()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        TravelTaxMixPanelAnalytics(action: .appdelegate, state: .info, data: MixPanelData(message: "applicationWillEnterForeground"))
        if UserDefaultModule.shared.getAccessToken() != "" {
            self.appRefreshDelegate?.didAppRefreshBegin()
//            NotificationCenter.default.post(name: Notification.Name("RefreshAppForeground"), object: nil)
            LocationManager.shared.setupLocationManager()
            LocationManager.shared.checkLocationService()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        TravelTaxMixPanelAnalytics(action: .appdelegate, state: .info, data: MixPanelData(message: "applicationDidBecomeActive"))
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Mixpanel.mainInstance().flush()
        LocationManager.shared.stopUpdateLocation()
        NetworkMonitor().stopMonitoring()
        UserLocationSetting.sharedInstance.isLocationAccessDenied = false
        TravelTaxMixPanelAnalytics(action: .appdelegate, state: .info, data: MixPanelData(message: "applicationWillTerminate"))
    }
    
}

 
extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted:Bool, error:Error?) in
            if error != nil {
                debugPrint((error?.localizedDescription)!)
                return
            }
            if granted {
                print("permission granted")
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                FirebaseApp.configure()
                Messaging.messaging().delegate = self
                Messaging.messaging().isAutoInitEnabled = true
                Messaging.messaging().token { fcmToken, errors in
                    if let error = error {
                        print("Error fetching FCM registration token: \(error)")
                      } else if let token = fcmToken {
                        print("FCM registration token: \(token)")
                      }
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    //MARK:- UNUserNotification Delegates
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        debugPrint(notification)
        NotificationCenter.default.post(name: Notification.Name("PushNotificationReceived"), object: nil, userInfo: nil)
        completionHandler([[.list, .banner, .badge, .sound]])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificationCenter.default.post(name: Notification.Name("PushNotificationReceived"), object: nil, userInfo: userInfo)
        print(userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
    
    func scheduleLocalNotification(alert:String) {
        let content = UNMutableNotificationContent()
        let requestIdentifier = UUID.init().uuidString
        
        content.badge = 0
        content.title = "Location Update"
        content.body = alert
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            print("Notification Register Success")
        }
    }
}


extension AppDelegate {

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("data of deviceToken \(deviceToken)")
        print("data of token \(token)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcm Toke: \(fcmToken ?? "nothing")")
        if let fcmToken = fcmToken {
            self.deviceToken = fcmToken
            if  let userID = UserDefaultModule.shared.getUserID(), userID != "" {
                registerAPIToken.RegisterTokenAPICall(userId: userID, token: self.deviceToken) { response in
                    print(response)
                    TravelTaxMixPanelAnalytics(action: .appdelegate, state: .info, data: MixPanelData(message: "Appdelegate - RegisterTokenAPICall success \(response), token:\(self.deviceToken)"))

                } onFailure: { error in
                    TravelTaxMixPanelAnalytics(action: .appdelegate, state: .info, data: MixPanelData(message: "Appdelegate - RegisterTokenAPICall failure  - Token: \(self.deviceToken) : \(error)"))
                    print(error)
                }
            }
        }
    }

}

public protocol RefreshAppDelegate: AnyObject {
    func didAppRefreshBegin()
}
