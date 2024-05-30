//
//  ProfileVoiceEditPopUpViewController.swift
//  YeonBa
//
//  Created by jin on 5/30/24.
//
import UIKit
import SnapKit
import Then

class ProfileVoiceEditPopUpViewController: UIViewController {
    private let popupView: ProfileVoiceEditPopUp
    private var vocalRange : String
    private var navigation : UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ...
        setupPopupViewActions()
    }
    
    init(title: String, desc: String, navigation: UINavigationController?, vocalRange : String) {
        self.popupView = ProfileVoiceEditPopUp(title: title, desc: desc, navigation: navigation, vocalRange : vocalRange)
        self.vocalRange = vocalRange
        self.navigation = navigation
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.snp.makeConstraints {
          $0.edges.equalToSuperview()
        }
      }
    
    private func setupPopupViewActions() {
        popupView.navigation = self.navigationController
        popupView.onDoneButtonTapped = { [weak self] in
            // 이 부분에서 dismiss를 호출하여 팝업을 닫습니다.
            self?.dismiss(animated: true, completion: {
                self?.navigateToProfileEditViewController()
            })
        }
    }

    private func navigateToProfileEditViewController() {
        if let navController = navigation {
            for controller in navController.viewControllers {
                if let profileEditVC = controller as? ProfileEditViewController {
                    profileEditVC.voiceSelected(self.vocalRange)
                    navController.popToViewController(profileEditVC, animated: true)
                    return
                }
            }
        }
    }
  
  required init?(coder: NSCoder) { fatalError() }
}

