//
//  LandingTabBarController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 04/04/23.
//

import UIKit

class LandingTabBarController: UITabBarController {

    // MARK: - Properties
    
    // MARK: - View life cycle
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: - Private methods
    
    /// SetupTabBar
    private func setupTabBar() {
//        self.tabBar.backgroundColor = UIColor.init(named: "appBackgroundColor", in: Bundle.main, compatibleWith: .current)
//        let welcome = WelcomeViewController.loadFromNib()
//        welcome.edgesForExtendedLayout = []
//        welcome.tabBarItem = UITabBarItem(title: "Welcome", image: UIImage(systemName: "square.and.arrow.up"), selectedImage: UIImage(systemName: "square.and.arrow.up"))
//        let navigationController = UINavigationController(rootViewController: welcome)
//        navigationController.navigationBar.isHidden = true
//
//        let vc2 = SignUpViewController.loadFromNib()
//        vc2.tabBarItem = UITabBarItem(title: "Check", image: UIImage(systemName: "pencil.circle"), selectedImage: UIImage(systemName: "pencil.circle"))
//        let nav2 = UINavigationController(rootViewController: vc2)
//        nav2.navigationBar.isHidden = true
//
//        self.selectedIndex = 1
//        viewControllers = [navigationController, nav2]
//
        
        self.tabBar.backgroundColor = UIColor.init(named: "WhiteAndBlack", in: Bundle.main, compatibleWith: .current)

        let v1 = DashBoardViewController.loadFromNib()
        let v2 = MyTravelListViewController.loadFromNib()
        let v3 = CreateNewTravelViewController.loadFromNib()
        let v4 = ExportViewController.loadFromNib()
        let v5 = SettingsViewController.loadFromNib()
        
        v1.edgesForExtendedLayout = []
        v1.tabBarItem = UITabBarItem(title: "Home", image:UIImage(named: "home-icon-normal") , selectedImage: UIImage(named: "homeSelected"))
        
        let navigationController = UINavigationController(rootViewController: v1)
        navigationController.viewWillAppear(true)
        navigationController.navigationBar.isHidden = true
        
        v2.edgesForExtendedLayout = []
        v2.tabBarItem = UITabBarItem(title: "Travel List", image:UIImage(named: "travelList"), selectedImage: UIImage(named: "travelListSelected"))
        let navigationController2 = UINavigationController(rootViewController: v2)
        navigationController2.navigationBar.isHidden = true
        
        v3.edgesForExtendedLayout = []
        v3.tabBarItem = UITabBarItem(title: "", image:UIImage(named: "createTravelPlus"), selectedImage: UIImage(named: "createTravelPlus"))
        v3.tabBarItem.imageInsets = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        v3.title = nil
        v3.modalPresentationStyle = .popover

        let navigationController3 = UINavigationController(rootViewController: v3)
        navigationController3.navigationBar.isHidden = true
        
        v4.edgesForExtendedLayout = []
        v4.tabBarItem = UITabBarItem(title: "Export", image: UIImage(named: "exportUnseelct") , selectedImage:UIImage(named: "exportSelect"))
        let navigationController4 = UINavigationController(rootViewController: v4)
        navigationController4.navigationBar.isHidden = true
        
        v5.edgesForExtendedLayout = []
        v5.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), selectedImage: UIImage(named: "settingsSelected"))
        let navigationController5 = UINavigationController(rootViewController: v5)
        navigationController5.navigationBar.isHidden = true
       

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.tabbarUnselectedTitleColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.tabbarSelectedTitleColor], for: .selected)

        self.tabBar.unselectedItemTintColor = UIColor.tabbarUnselectedTitleColor
        self.selectedIndex = 1
        viewControllers = [navigationController, navigationController2,navigationController3,navigationController4,navigationController5]
        
        
//        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Home", image: UIImage(named: "home-icon-normal"), selectedImage: UIImage(named: "home-icon-normal"))
//        v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Favor", image: UIImage(named: "Travel-history-icon"), selectedImage: UIImage(named: "Travel-history-icon"))
//        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "Add-new-icon"), selectedImage: UIImage(named: "Add-new-icon"))
//        v4.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Dashboard", image: UIImage(named: "Profile-icon"), selectedImage: UIImage(named: "Profile-icon"))
//        v5.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Me", image: UIImage(named: "settings-icon"), selectedImage: UIImage(named: "settings-icon"))
//        tabBarController.viewControllers = [v1,v4,v5] // [v1, v2 , v3, v4, v5]
//            tabBarController.selectedViewController = v1
//
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let nav1 = UINavigationController()
//        nav1.isNavigationBarHidden = true
//        nav1.viewControllers = [tabBarController]
//        self.window!.rootViewController = nav1
//        self.window?.makeKeyAndVisible()
        
    }
    
    // MARK: - User interactions
    
}
