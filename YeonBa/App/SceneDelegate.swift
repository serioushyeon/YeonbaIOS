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
        window?.backgroundColor = UIColor.tabBack
        
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
            items[0].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.primary], for: .selected)
            
            items[1].selectedImage = UIImage(named: "FillSearch")
            items[1].image = UIImage(named: "Search")
            items[1].title = "찾아보기"
            items[1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.primary], for: .selected)
            
            items[2].selectedImage = UIImage(named: "FillCollect")
            items[2].image = UIImage(named: "Collect")
            items[2].title = "모아보기"
            items[2].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.primary], for: .selected)
            
            items[3].selectedImage = UIImage(named: "FillChatting")
            items[3].image = UIImage(named: "Chatting")
            items[3].title = "채팅"
            items[3].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.primary], for: .selected)
            
            items[4].selectedImage = UIImage(named: "FillSetting")
            items[4].image = UIImage(named: "Setting")
            items[4].title = "마이페이지"
            items[4].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.primary], for: .selected)
        }
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

