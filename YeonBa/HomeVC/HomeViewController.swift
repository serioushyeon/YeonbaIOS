//
//  HomeViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 2/29/24.
//

import UIKit
import SnapKit
import Then

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        navigationControl()
    }
    // MARK: - Navigation
    func navigationControl() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let titleLabel = UILabel()
        titleLabel.text = "Yeonba"
        titleLabel.textColor = .black // 네비게이션 바의 텍스트 색상을 지정합니다.
        titleLabel.sizeToFit() // 라벨 크기를 적절히 조정합니다.
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        let heartButton = UIBarButtonItem(image: UIImage(named: "Heart"), style: .plain, target: self, action: #selector(heartButtonTapped))
        let alarmButton = UIBarButtonItem(image: UIImage(named: "Alarm"), style: .plain, target: self, action: #selector(alarmButtonTapped))
            
        navigationItem.rightBarButtonItems = [alarmButton, heartButton]
    }


    func configUI() {
        
    }
    @objc func heartButtonTapped() {
        print("heart button tapped")
    }
    @objc func alarmButtonTapped() {
        print("tabbar button tapped")
    }
   

}
