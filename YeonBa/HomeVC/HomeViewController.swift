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
    private let heartImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "Homeheart")
    }
    private let heartLabel = UILabel().then {
        $0.text = "231"
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardRegular(size: 13)
    }
    private let favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: "Favorites"), for: .normal)
    }
    private let animalButton = UIButton().then {
        $0.setTitle("강아지 상", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 13)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.setTitleColor(.black, for: .normal)
    }
    private let voiceButton = UIButton().then {
        $0.setTitle("저음", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 13)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.setTitleColor(.black, for: .normal)
    }
    private let cardView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1.0
        
    }
    private let secondCardView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1.0
        
    }
    private let mySecondImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    private let secondMyNameLabel = UILabel().then {
        $0.text = "유지민"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    private let secondMyAgeLabel = UILabel().then {
        $0.text = "25"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 16)
    }
    private let secondHeartImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "Homeheart")
    }
    private let secondHeartLabel = UILabel().then {
        $0.text = "200"
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardRegular(size: 13)
    }
    private let secondAnimalButton = UIButton().then {
        $0.setTitle("고양이 상", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 13)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.setTitleColor(.black, for: .normal)
    }
    private let secondVoiceButton = UIButton().then {
        $0.setTitle("고음", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 13)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.setTitleColor(.black, for: .normal)
    }
    private let secondFavoriteButton = UIButton().then {
        $0.setImage(UIImage(named: "Favorites"), for: .normal)
    }
    private let recommendButton = ActualGradientButton().then {
        $0.setTitle("새로운 추천 이성", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        let image = UIImage(named: "Replay")
        $0.setImage(image, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    
    private let barView = UIView().then {
        $0.layer.backgroundColor = UIColor.init(named: "gray")?.cgColor
    }
    private let sendGender = UILabel().then {
        $0.text = "최근에 화살을 보낸 이성"
        $0.textColor = UIColor.black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 18)
    }
    private let plusGenderButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 13)
        $0.setTitleColor(UIColor.gray, for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configUI()
        loadImage()
        secondLoadImage()
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
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        let heartButton = UIBarButtonItem(image: UIImage(named: "Heart"), style: .plain, target: self, action: #selector(heartButtonTapped))
        
        let heartCountLabel = UILabel()
        heartCountLabel.text = "5" // 초기 하트 개수
        heartCountLabel.textColor = UIColor.primary
        heartCountLabel.sizeToFit()
        let heartCountBarButton = UIBarButtonItem(customView: heartCountLabel)
        
        let alarmButton = UIBarButtonItem(image: UIImage(named: "Alarm"), style: .plain, target: self, action: #selector(alarmButtonTapped))
        
        navigationItem.rightBarButtonItems = [alarmButton, heartCountBarButton, heartButton]
    }
    // MARK: - UI Layout
    func addSubviews() {
        view.addSubview(mainScrollview)
        mainScrollview.addSubview(contentView)
        contentView.addSubview(recommendTitle)
        contentView.addSubview(cardView)
        cardView.addSubview(myImageView)
        cardView.addSubview(myNameLabel)
        cardView.addSubview(myAgeLabel)
        cardView.addSubview(heartImage)
        cardView.addSubview(heartLabel)
        cardView.addSubview(animalButton)
        cardView.addSubview(voiceButton)
        cardView.addSubview(favoriteButton)
        contentView.addSubview(secondCardView)
        secondCardView.addSubview(mySecondImageView)
        secondCardView.addSubview(secondMyNameLabel)
        secondCardView.addSubview(secondMyAgeLabel)
        secondCardView.addSubview(secondHeartImage)
        secondCardView.addSubview(secondHeartLabel)
        secondCardView.addSubview(secondAnimalButton)
        secondCardView.addSubview(secondVoiceButton)
        secondCardView.addSubview(secondFavoriteButton)
        contentView.addSubview(recommendButton)
        contentView.addSubview(barView)
        contentView.addSubview(sendGender)
        contentView.addSubview(plusGenderButton)
    }
    
    func configUI() {
        mainScrollview.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top) // 네비게이션 바 아래부터 시작하고 40의 마진을 두도록 설정
            $0.leading.trailing.bottom.equalToSuperview() // 나머지 영역은 부모 뷰와 같도록 설정
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(800)
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
        myAgeLabel.snp.makeConstraints {
            $0.leading.equalTo(myNameLabel.snp.trailing).offset(7)
            $0.bottom.equalTo(myNameLabel.snp.bottom)
        }
        heartImage.snp.makeConstraints {
            $0.top.equalTo(myNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(myNameLabel.snp.leading)
        }
        heartLabel.snp.makeConstraints {
            $0.top.equalTo(heartImage.snp.top)
            $0.leading.equalTo(heartImage.snp.trailing).offset(3)
        }
        animalButton.snp.makeConstraints {
            $0.top.equalTo(heartImage.snp.bottom).offset(10)
            $0.leading.equalTo(heartImage.snp.leading)
        }
        voiceButton.snp.makeConstraints {
            $0.top.equalTo(animalButton.snp.bottom).offset(5)
            $0.leading.equalTo(animalButton.snp.leading)
        }
        favoriteButton.snp.makeConstraints {
            $0.width.equalTo(16)
            $0.height.equalTo(20)
            $0.top.equalTo(cardView.snp.top).offset(15)
            $0.trailing.equalTo(cardView.snp.trailing).offset(-15)
        }
        secondCardView.snp.makeConstraints {
            $0.width.equalTo(352)
            $0.height.equalTo(168)
            $0.top.equalTo(cardView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20) // 좌측에서 20만큼 떨어진 위치
        }
        mySecondImageView.snp.makeConstraints {
            $0.width.equalTo(142)
            $0.height.equalTo(142)
            $0.top.equalTo(secondCardView.snp.top).offset(10)
            $0.leading.equalTo(secondCardView.snp.leading).offset(10)
        }
        secondMyNameLabel.snp.makeConstraints {
            $0.top.equalTo(secondCardView.snp.top).offset(15)
            $0.leading.equalTo(mySecondImageView.snp.trailing).offset(15)
        }
        secondMyAgeLabel.snp.makeConstraints {
            $0.leading.equalTo(secondMyNameLabel.snp.trailing).offset(7)
            $0.bottom.equalTo(secondMyNameLabel.snp.bottom)
        }
        secondHeartImage.snp.makeConstraints {
            $0.top.equalTo(secondMyNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(secondMyNameLabel.snp.leading)
        }
        secondHeartLabel.snp.makeConstraints {
            $0.top.equalTo(secondHeartImage.snp.top)
            $0.leading.equalTo(secondHeartImage.snp.trailing).offset(3)
        }
        secondAnimalButton.snp.makeConstraints {
            $0.top.equalTo(secondHeartImage.snp.bottom).offset(10)
            $0.leading.equalTo(secondHeartImage.snp.leading)
        }
        secondVoiceButton.snp.makeConstraints {
            $0.top.equalTo(secondAnimalButton.snp.bottom).offset(5)
            $0.leading.equalTo(secondAnimalButton.snp.leading)
        }
        secondFavoriteButton.snp.makeConstraints {
            $0.width.equalTo(16)
            $0.height.equalTo(20)
            $0.top.equalTo(secondCardView.snp.top).offset(15)
            $0.trailing.equalTo(secondCardView.snp.trailing).offset(-15)
        }
        recommendButton.snp.makeConstraints {
            $0.width.equalTo(163)
            $0.height.equalTo(46)
            $0.top.equalTo(secondCardView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview() // 가운데 정렬
        }
        barView.snp.makeConstraints {
            $0.width.equalTo(353)
            $0.height.equalTo(1)
            $0.top.equalTo(recommendButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(21)
        }
        sendGender.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(barView.snp.bottom).offset(20)
        }
        plusGenderButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(sendGender.snp.bottom).offset(6)
        }
        
    }
    private func loadImage() {
        guard let url = URL(string:"https://newsimg.sedaily.com/2023/09/12/29UNLQFQT6_1.jpg") else { return }
        myImageView.kf.setImage(with: url)
    }
    private func secondLoadImage() {
        guard let url = URL(string:"https://img.sportsworldi.com/content/image/2023/10/09/20231009517485.jpg") else { return }
        mySecondImageView.kf.setImage(with: url)
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
    static func pretendardRegular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Pretendard-Regular", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
}
