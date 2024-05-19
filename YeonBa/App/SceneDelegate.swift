//
//  SceneDelegate.swift
//  YeonBa
//
//  Created by 김민솔 on 2024/02/29.
//

import UIKit
import KakaoSDKAuth
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let windowScene = (scene as? UIWindowScene) else {return}
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = SplashViewController()

        let navigationController = BaseNavigationController(rootViewController: viewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let userID = KeychainHandler.shared.userID
        
        if !userID.isEmpty {
            appleIDProvider.getCredentialState(forUserID: userID ) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    print("해당 ID는 연동되어있습니다.")
                case .revoked, .notFound:
                    print("해당 ID는 연동되어있지않습니다.")
                    DispatchQueue.main.async {
                        let splashViewController = SplashViewController()
                        let navigationController = BaseNavigationController(rootViewController: splashViewController)
                        self.window?.rootViewController = navigationController
                        self.window?.makeKeyAndVisible()

                    }
                default:
                    break
                }
            }
        }
    }
    
}
