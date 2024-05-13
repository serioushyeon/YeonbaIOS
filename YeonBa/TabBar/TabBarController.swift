//
//  tabBarController.swift
//  YeonBa
//
//  Created by 김민솔 on 2/29/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
    }
    private func setupViewControllers() {
        let homeViewController = HomeViewController()
        let searchViewController = SearchViewController()
        let collectViewController = CollectViewController()
        let chattingViewController = ChattingViewController()
        let settingViewController = SettingViewController()
        
        homeViewController.tabBarItem = UITabBarItem(title: "홈화면", image: UIImage(systemName: "Home"), selectedImage: UIImage(systemName: "FillHome"))
        searchViewController.tabBarItem = UITabBarItem(title: "찾아보기", image: UIImage(systemName: "Search"), selectedImage: UIImage(systemName: "FillSearch"))
        collectViewController.tabBarItem = UITabBarItem(title: "모아보기", image: UIImage(systemName: "Collect"), selectedImage: UIImage(systemName: "FillCollect"))
        chattingViewController.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(systemName: "Chatting"), selectedImage: UIImage(systemName: "FillChatting"))
        settingViewController.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "Setting"), selectedImage: UIImage(systemName: "FillSetting"))
        let controllers = [homeViewController, searchViewController, collectViewController, chattingViewController,settingViewController]
        self.viewControllers = controllers.map {BaseNavigationController(rootViewController: $0)}

    }
    private func setupTabBarAppearance() {
        tabBar.isTranslucent = false
        setTabBarColors(
            backgroundColor: .white,
            tintColor: .primary!,
            unselectedItemTintColor: .gray
        )
    }
    
    private func setTabBarColors(backgroundColor: UIColor, tintColor: UIColor, unselectedItemTintColor: UIColor) {
        tabBar.backgroundColor = backgroundColor
        tabBar.tintColor = tintColor
        tabBar.unselectedItemTintColor = unselectedItemTintColor
    }

}

