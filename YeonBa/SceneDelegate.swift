//
//  SceneDelegate.swift
//  YeonBa
//
//  Created by 김민솔 on 2024/02/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
            window = UIWindow(windowScene: windowScene)
            window?.backgroundColor = .white
            
            let firstViewController = UINavigationController(rootViewController: HomeViewController())
            let secondViewController = UINavigationController(rootViewController: SearchViewController())
            let thirdViewController = UINavigationController(rootViewController: CollectViewController())
            let fourthViewController = UINavigationController(rootViewController: ChattingViewController())
            let fifthViewController = UINavigationController(rootViewController: SettingViewController())
        
            let tabBarController = UITabBarController()
            tabBarController.setViewControllers([firstViewController, secondViewController,thirdViewController,fourthViewController,fifthViewController], animated: true)
        
        if let items = tabBarController.tabBar.items{
            let KeyColor = UIColor(named: "KeyColor")
            
            items[0].selectedImage = UIImage(named: "FillHome")
            items[0].image = UIImage(named: "Home")
            items[0].title = "홈화면"
            
            if let KeyColor = KeyColor {
                items[0].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: KeyColor], for: .selected)
            }
            
            items[1].selectedImage = UIImage(named: "FillSearch")
            items[1].image = UIImage(named: "Search")
            items[1].title = "찾아보기"
            
            if let KeyColor = KeyColor {
                items[1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: KeyColor], for: .selected)
            }
            
            items[2].selectedImage = UIImage(named: "FillCollect")
            items[2].image = UIImage(named: "Collect")
            items[2].title = "모아보기"
            
            if let KeyColor = KeyColor {
                items[2].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: KeyColor], for: .selected)
            }
            
            items[3].selectedImage = UIImage(named: "FillChatting")
            items[3].image = UIImage(named: "Chatting")
            items[3].title = "채팅"
            
            if let KeyColor = KeyColor {
                items[3].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: KeyColor], for: .selected)
            }
            
            items[4].selectedImage = UIImage(named: "FillSetting")
            items[4].image = UIImage(named: "Setting")
            items[4].title = "마이페이지"
            
            if let KeyColor = KeyColor {
                items[4].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: KeyColor], for: .selected)
            }
            
            
        }
        
        
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
