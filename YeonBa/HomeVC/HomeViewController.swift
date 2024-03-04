//
//  HomeViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 2/29/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class HomeViewController: UIViewController {
    // MARK: - UI Components
    //스크롤 뷰
    private let mainScrollview = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let recommendTitle = UILabel().then {
        $0.text = "회원님을 위한 추천 이성"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 18)
        
    }
    private let myImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    private let myNameLabel = UILabel().then {
        $0.text = "윤정스"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    private let myAgeLabel = UILabel().then {
        $0.text = "27"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 16)
    }
    private let cardView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1.0
        
    }
    
    
    override func viewDidLoad() { //함수만 작성 !!
        super.viewDidLoad()
        addSubviews()
        configUI()
        loadImage()
        checkfont()
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
    // MARK: - UI Layout
    func addSubviews() {
        view.addSubview(mainScrollview)
        mainScrollview.addSubview(contentView)
        contentView.addSubview(recommendTitle)
        contentView.addSubview(cardView)
        cardView.addSubview(myImageView)
        cardView.addSubview(myNameLabel)
        //cardView.addSubview(myAgeLabel)
    }
    
    func configUI() {
        mainScrollview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        recommendTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
        }
        cardView.snp.makeConstraints {
            $0.width.equalTo(352)
            $0.height.equalTo(168)
            $0.top.equalTo(recommendTitle.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20) // 좌측에서 20만큼 떨어진 위치
        }
        myImageView.snp.makeConstraints {
            $0.width.equalTo(142)
            $0.height.equalTo(142)
            $0.top.equalTo(cardView.snp.top).offset(10)
            $0.leading.equalTo(cardView.snp.leading).offset(10)
        }
        myNameLabel.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.top).offset(15)
            $0.leading.equalTo(myImageView.snp.trailing).offset(15)
        }
        
    }
    private func loadImage() {
        guard let url = URL(string:"https://newsimg.sedaily.com/2023/09/12/29UNLQFQT6_1.jpg") else { return }
        myImageView.kf.setImage(with: url)
    }
    func checkfont() {
        for family in UIFont.familyNames {
            print(family)
            for name in UIFont.fontNames(forFamilyName: family) {
                print(name)
            }
        }
    }
    // MARK: - Actions
    @objc func heartButtonTapped() {
        print("heart button tapped")
    }
    @objc func alarmButtonTapped() {
        print("tabbar button tapped")
    }
   

}
extension UIFont {
    static func pretendardSemiBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Pretendard-SemiBold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        return font
    }
}
