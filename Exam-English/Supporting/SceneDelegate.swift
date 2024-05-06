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
        
//        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
//        let navigationController = UINavigationController(rootViewController: loginViewController)
        let studyViewController = StudyViewController(nibName: "StudyViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: studyViewController)
        window.rootViewController = navigationController
        
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

