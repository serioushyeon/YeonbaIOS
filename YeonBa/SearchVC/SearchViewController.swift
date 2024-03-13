//
//  SearchViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 2/29/24.
//

import UIKit
import Then
import SnapKit

class SearchViewController: UIViewController {
    private let verticalStackview = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 10
    }
    private let ageSlider = JKSlider().then {
        $0.minValue = 1
        $0.maxValue = 100
        $0.lower = 1
        $0.upper = 75
    }
    private let locationLabel = UILabel().then {
        $0.text = "지역"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    private let locationView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let locationChoiceLabel = UILabel().then {
        $0.text = "전체"
        $0.textColor = UIColor.gray
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textAlignment = .center
    }
    private let locationChoiceBtn = UIButton().then {
        $0.setImage(UIImage(named: "nextBtn"), for: .normal)
    }
    private let barView = UIView().then {
        $0.layer.borderColor = UIColor.init(named: "gray")?.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
    }
    private let voiceLabel = UILabel().then {
        $0.text = "음역대"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    private let voiceView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let voiceChoiceLabel = UILabel().then {
        $0.text = "전체"
        $0.textColor = UIColor.gray
        $0.font = UIFont.pretendardRegular(size: 16)
        $0.textAlignment = .center
    }
    private let vocieChoiceBtn = UIButton().then {
        $0.setImage(UIImage(named: "nextBtn"), for: .normal)
    }
    private let barView2 = UIView().then {
        $0.layer.borderColor = UIColor.init(named: "gray")?.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
    }
    private let weightLabel = UILabel().then {
        $0.text = "체형"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    private let weightView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let weightChoiceLabel = UILabel().then {
        $0.text = "전체"
        $0.textColor = UIColor.gray
        $0.font = UIFont.pretendardRegular(size: 16)
        $0.textAlignment = .center
    }
    private let weightChoiceBtn = UIButton().then {
        $0.setImage(UIImage(named: "nextBtn"), for: .normal)
    }
    private let barView3 = UIView().then {
        $0.layer.borderColor = UIColor.init(named: "gray")?.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
    }
    private let ageLabel = UILabel().then {
        $0.text = "나이"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    private let ageRangeLabel = UILabel().then {
        $0.text = "20~25세"
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 16)
    }
    private let barView4 = UIView().then {
        $0.layer.borderColor = UIColor.init(named: "gray")?.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
    }
    private let HeightLabel = UILabel().then {
        $0.text = "키"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    private let heightSlider = JKSlider().then {
        $0.minValue = 1
        $0.maxValue = 100
        $0.lower = 1
        $0.upper = 75
    }
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        
    }
    private let meetAnimalLabel = UILabel().then {
        $0.text = "선호하는 동물 상 만나기"
        $0.textColor = UIColor.thirdary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardMedium(size: 16)
    }
    private let animalCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "checkbox"), for: .normal)
    }
//    private let findBtn = UIButton().then {
//        
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControl()
        addSubviews()
        configUI()
        
        
    }
    

    // MARK: - Navigation
    func navigationControl() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.title = "찾아보기"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    func addSubviews() {
        view.addSubview(verticalStackview)
        verticalStackview.addArrangedSubview(locationLabel)
        verticalStackview.addArrangedSubview(locationView)
        verticalStackview.addArrangedSubview(barView)
        locationView.addSubview(locationChoiceLabel)
        locationView.addSubview(locationChoiceBtn)
        verticalStackview.addArrangedSubview(voiceLabel)
        verticalStackview.addArrangedSubview(voiceView)
        verticalStackview.addArrangedSubview(barView2)
        voiceView.addSubview(voiceChoiceLabel)
        voiceView.addSubview(vocieChoiceBtn)
        
        verticalStackview.addArrangedSubview(weightLabel)
        verticalStackview.addArrangedSubview(weightView)
        verticalStackview.addArrangedSubview(barView3)
        weightView.addSubview(weightChoiceLabel)
        weightView.addSubview(weightChoiceBtn)
        verticalStackview.addArrangedSubview(ageLabel)
        verticalStackview.addArrangedSubview(ageSlider)
        verticalStackview.addArrangedSubview(barView4)
        verticalStackview.addArrangedSubview(HeightLabel)
        verticalStackview.addArrangedSubview(heightSlider)
        verticalStackview.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(meetAnimalLabel)
        horizontalStackView.addArrangedSubview(animalCheckBox)
        
    }
    func configUI() {
        verticalStackview.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        locationView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        locationChoiceLabel.snp.makeConstraints {
               $0.top.equalToSuperview().offset(15)
               $0.leading.equalToSuperview().offset(20)
        }
       // locationChoiceBtn의 제약 설정
       locationChoiceBtn.snp.makeConstraints {
           $0.top.equalToSuperview().offset(15)
           $0.trailing.equalToSuperview().offset(-15)
       }
        barView.snp.makeConstraints {
            $0.top.equalTo(locationView.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        voiceView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        voiceChoiceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(20)
        }
        vocieChoiceBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        barView2.snp.makeConstraints {
            $0.top.equalTo(voiceView.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        weightView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        weightChoiceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(20)
        }
        weightChoiceBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        barView3.snp.makeConstraints {
            $0.top.equalTo(weightView.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        ageSlider.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        barView4.snp.makeConstraints {
            $0.top.equalTo(ageSlider.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        heightSlider.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
//        horizontalStackView.snp.makeConstraints {
//
//        }
                    
    }
    

}
