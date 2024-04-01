//
//  SettingViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 2/29/24.
//

import UIKit
import SnapKit
import Then

class SettingViewController: UIViewController {

    // MARK: - UI Components
    private let scrollview = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let imageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        let image = UIImage(named: "profilering") // 이미지 이름에 따라 수정하세요
        $0.image = image
    }
    private let nameLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "연바" // 원하는 이름으로 수정
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 24) // 볼드체로 설정하고 크기를 24로 설정
    }
    let nameLabel2 = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Today"
        $0.textAlignment = .center
        $0.textColor = .black // 원하는 색상으로 설정하세요
    }
    
    private let button1 = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("프로필 수정하기", for: .normal)
        $0.layer.borderWidth = 2.0 // 테두리 두께
        $0.layer.borderColor = UIColor.black.cgColor // 테두리 색상
        $0.layer.cornerRadius = 20.0 // 테두리 둥글기 반지름
        $0.setTitleColor(UIColor.black, for: .normal) // 텍스트 색상
        $0.setImage(UIImage(named: "profile")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .black
        $0.contentHorizontalAlignment = .center // 버튼1 이미지를 가로로 가운데 정렬
    }
    private let button2 = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("남은 화살 수", for: .normal)
        $0.layer.cornerRadius = 20.0 // 테두리 둥글기 반지름
        $0.backgroundColor = UIColor(named: "KeyColor") // 배경색
        $0.setTitleColor(UIColor.white, for: .normal) // 텍스트 색상
        $0.setImage(UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .white
        $0.contentHorizontalAlignment = .center // 버튼2 이미지를 가로로 가운데 정렬
    }
    private let bottomView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configUI()
        
    }
    
    //MARK: - UI Layout
    func addSubviews() {
        view.addSubview(scrollview)
        scrollview.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameLabel2)
        contentView.addSubview(button1)
        contentView.addSubview(button2)
        contentView.addSubview(bottomView)
    }
    
    func configUI() {
        //snapkit 라이브러리
        scrollview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1100)
            $0.top.bottom.equalToSuperview().inset(70) // 모든 UI 요소를 아래로 100 포인트 내립니다.
        }
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top).offset(-20)
            make.width.height.equalTo(150)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        nameLabel2.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(10) // 이름 레이블 옆에 10 포인트 간격으로 설정
            make.centerY.equalTo(nameLabel) // 이름 레이블과 수직 정렬        }
            
        // Button1
        button1.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(174)
            make.height.equalTo(40)
        }
        
        // Button2
        button2.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(174)
            make.height.equalTo(40)
        }
            
        let views = (0..<8).map { _ in UIView() }
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.backgroundColor = UIColor(named: "SettingColor")
        bottomView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview() // 수직 스택 뷰의 상단과 하단을 부모 뷰에 맞춥니다.
            make.leading.trailing.equalToSuperview() // 수직 스택 뷰의 좌우를 부모 뷰에 맞춥니다.
        }
        
        let labelTitles = ["지인 만나지 않기", "알림 설정", "계정 관리", "차단 관리", "화살 충전", "고객 센터", "이용 약관/개인정보 취급 방침", "공지 사항"]
        let buttonTitles = ["버튼 1", "버튼 2", "버튼 3", "버튼 4", "버튼 5", "버튼 6", "버튼 7", "버튼 8"]


        views.enumerated().forEach { index, view in
            let label = UILabel()
            let title = labelTitles[index] // 각 버튼에 다른 이름을 할당합니다.
            label.text = title // 레이블에 텍스트를 설정합니다.
            label.textColor = .black // 텍스트 색상을 지정합니다.
            label.backgroundColor = UIColor(named: "SettingColor")
            view.addSubview(label)
            
            label.snp.makeConstraints { make in
               // make.centerX.centerY.equalToSuperview()
                make.top.bottom.equalToSuperview() // 버튼을 상하로 가득 채우도록 설정합니다.
                //make.leading.equalToSuperview() // 버튼을 부모 뷰의 leading edge에 맞춥니다.
                make.leading.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(index * 80) // 상단에서 index * 80만큼 떨어지도록 설정합니다.
                make.width.equalTo(393)
                make.height.equalTo(200)
                
            }
            
            
            // 버튼 생성 및 설정
            let button = UIButton()
            let buttonTitle = buttonTitles[index] // 각 버튼에 다른 이름을 할당합니다.
            // 이미지 설정
            let image = UIImage(named: "allow") // 이미지 이름에 따라 수정하세요
            button.setImage(image, for: .normal)

            view.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(10)
                make.centerY.equalToSuperview()
                make.width.equalTo(80)
                make.height.equalTo(40)
            }
            

        bottomView.snp.makeConstraints { make in
            make.top.equalTo(button1.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(700)
        }
            
        }
        
            
            // MARK: - Actions
            
            
            
        }
    }
}
