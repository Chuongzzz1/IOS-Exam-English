//
//  SceneDelegate.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 14/04/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        
//        // login
//        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
//        let loginNavi = UINavigationController(rootViewController: loginVC)
//        window.rootViewController = loginNavi
        
        let testVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let testNavi = UINavigationController(rootViewController: testVC)
        window.rootViewController = testNavi

        self.window = window
    }
    
    func createTabBarController() -> UITabBarController {
        // home
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let homeNavi = UINavigationController(rootViewController: homeVC)
        let homeTabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home-off"), selectedImage: UIImage(named: "home-on"))
        homeTabBarItem.tag = 0
        homeVC.tabBarItem = homeTabBarItem

        // study
        let studyVC = StudyViewController(nibName: "StudyViewController", bundle: nil)
        let studyNavi = UINavigationController(rootViewController: studyVC)
        let studyTabBarItem = UITabBarItem(title: "Study", image: UIImage(named: "study-off"), selectedImage: UIImage(named: "study-on"))
        studyTabBarItem.tag = 1
        studyVC.tabBarItem = studyTabBarItem
        
        // tabbar
        let tabbarController = UITabBarController()
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            Authentication.shared.scheduleRefreshAccessToken(accessToken: accessToken)
        }
        tabbarController.viewControllers = [homeNavi, studyNavi]
        tabbarController.tabBar.tintColor = UIColor(named: Constants.Color.mainColor)
//        tabbarController.tabBar.backgroundColor = UIColor(named: "D9DDDE")
        
        return tabbarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

