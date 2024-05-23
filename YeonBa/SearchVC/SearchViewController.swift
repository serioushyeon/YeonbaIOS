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
    private var voiceViewMode: VoiceMode = .high
    private var weightViewMode: WeightMode = .empty
    private var locationViewMode: LocationMode = .empty
    private var ageSelectedMode: String?
    private var heightSelectedMode: String?
    private var preferLocation : String?
    private var preferVoice : String?
    var isAnimalPreferred: Bool = false
    private let verticalStackview = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 10
    }
    private let ageSlider = JKSlider().then {
        $0.minValue = 20
        $0.maxValue = 40
        $0.lower = 20
        $0.upper = 40
        $0.addTarget(self, action: #selector(ageChangeValue), for: .valueChanged)
    }
    private let locationLabel = UILabel().then {
        $0.text = "지역"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 18)
    }
    private let locationView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customgray2?.cgColor
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
        $0.layer.borderColor = UIColor.customgray2?.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
    }
    private let voiceLabel = UILabel().then {
        $0.text = "음역대"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 18)
    }
    private let voiceView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customgray2?.cgColor
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
        $0.layer.borderColor = UIColor.customgray2?.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
    }
    private let weightLabel = UILabel().then {
        $0.text = "체형"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 18)
    }
    private let weightView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customgray2?.cgColor
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
        $0.layer.borderColor = UIColor.customgray2?.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
    }
    private let ageHorizontalStackview = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .bottom
        $0.spacing = 10
    }
    private let ageLabel = UILabel().then {
        $0.text = "나이"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 18)
    }
    private let ageRangeLabel = UILabel().then {
        $0.text = "20~25세"
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 16)
    }
    private let barView4 = UIView().then {
        $0.layer.borderColor = UIColor.customgray2?.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
    }
    private let heightHorizontalStackview = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .bottom
        $0.spacing = 10
    }
    private let HeightLabel = UILabel().then {
        $0.text = "키"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 18)
    }
    private let heightRangeLabel = UILabel().then {
        $0.text = "160cm~170cm"
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 16)
    }
    private let heightSlider = JKSlider().then {
        $0.minValue = 140
        $0.maxValue = 220
        $0.lower = 140
        $0.upper = 220
        $0.addTarget(self, action: #selector(heightChangeValue), for: .valueChanged)
    }
    private let barView5 = UIView().then {
        $0.layer.borderColor = UIColor.customgray2?.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
    }
    private let animalHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 5
        
    }
    private let meetAnimalLabel = UILabel().then {
        $0.text = "선호하는 동물 상 만나기"
        $0.textColor = UIColor.thirdary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardMedium(size: 15)
    }
    private let animalCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "checkbox"), for: .normal)
        $0.addTarget(self, action: #selector(animalButtonTapped), for: .touchUpInside)

    }
    private let findButton = ActualGradientButton().then {
        $0.setTitle("이성 찾기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(navigateToSearchResultViewController), for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationControl()
        addSubviews()
        configUI()
        tapGesture()
        
    }
    

// MARK: - Navigation
    func navigationControl() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.title = "찾아보기"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
//MARK: -- UI
    func addSubviews() {
        view.addSubview(verticalStackview)
        verticalStackview.addArrangedSubview(locationLabel)
        verticalStackview.addArrangedSubview(locationView)
        locationView.addSubview(locationChoiceLabel)
        locationView.addSubview(locationChoiceBtn)
        verticalStackview.addArrangedSubview(barView)
        verticalStackview.addArrangedSubview(voiceLabel)
        verticalStackview.addArrangedSubview(voiceView)
        voiceView.addSubview(voiceChoiceLabel)
        voiceView.addSubview(vocieChoiceBtn)
        verticalStackview.addArrangedSubview(barView2)
        verticalStackview.addArrangedSubview(weightLabel)
        verticalStackview.addArrangedSubview(weightView)
        verticalStackview.addArrangedSubview(barView3)
        verticalStackview.addArrangedSubview(ageHorizontalStackview)
        ageHorizontalStackview.addArrangedSubview(ageLabel)
        ageHorizontalStackview.addArrangedSubview(ageRangeLabel)
        verticalStackview.addArrangedSubview(ageSlider)
        weightView.addSubview(weightChoiceLabel)
        weightView.addSubview(weightChoiceBtn)
        
        verticalStackview.addArrangedSubview(barView4)
        verticalStackview.addArrangedSubview(heightHorizontalStackview)
        heightHorizontalStackview.addArrangedSubview(HeightLabel)
        heightHorizontalStackview.addArrangedSubview(heightRangeLabel)
        verticalStackview.addArrangedSubview(heightSlider)
        verticalStackview.addArrangedSubview(barView5)
        verticalStackview.addArrangedSubview(animalHorizontalStackView)
        animalHorizontalStackView.addArrangedSubview(meetAnimalLabel)
        animalHorizontalStackView.addArrangedSubview(animalCheckBox)
        view.addSubview(findButton)
    }
    func tapGesture() {
        locationView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showLocationModal))
        locationView.addGestureRecognizer(tapGesture)
        
        voiceView.isUserInteractionEnabled = true
        let voicetapGesture = UITapGestureRecognizer(target: self, action: #selector(voiceModal))
        voiceView.addGestureRecognizer(voicetapGesture)
        
        weightView.isUserInteractionEnabled = true
        let weighttapGesture = UITapGestureRecognizer(target: self, action: #selector(weightModal))
        weightView.addGestureRecognizer(weighttapGesture)
    }
    func configUI() {
        verticalStackview.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        locationLabel.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.03) // 수직 스택뷰 높이의 5%로 설정
        }
        locationView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.09) // 수직 스택뷰 높이의 5%로 설정
            $0.leading.trailing.equalToSuperview()
        }
        locationChoiceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        locationChoiceBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
        }
        barView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        voiceLabel.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.03) // 수직 스택뷰 높이의 5%로 설정
        }
        voiceView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.09) // 수직 스택뷰 높이의 5%로 설정
            $0.leading.trailing.equalToSuperview()
        }
        voiceChoiceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        vocieChoiceBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
        }
        barView2.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        weightLabel.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.03) // 수직 스택뷰 높이의 5%로 설정
        }
        weightView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.09) // 수직 스택뷰 높이의 5%로 설정
            $0.leading.trailing.equalToSuperview()
        }
        weightChoiceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        weightChoiceBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
        }
        barView3.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        ageHorizontalStackview.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.04) // 수직 스택뷰 높이의 5%로 설정
            $0.leading.trailing.equalToSuperview()
        }
        ageSlider.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.08) // 수직 스택뷰 높이의 5%로 설정
            $0.leading.trailing.equalToSuperview()
        }
        barView4.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }

        heightHorizontalStackview.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.04) // 수직 스택뷰 높이의 5%로 설정
            $0.leading.trailing.equalToSuperview()
        }
        
        heightSlider.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.08) // 수직 스택뷰 높이의 5%로 설정
            $0.leading.trailing.equalToSuperview()
        }
        barView5.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        animalHorizontalStackView.snp.makeConstraints {
           // $0.height.equalToSuperview().multipliedBy(0.05)
            $0.leading.trailing.equalToSuperview()
        }
        
        animalCheckBox.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.width.equalTo(28)
        }
        findButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(verticalStackview.snp.bottom).offset(10)
           // $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.height.equalToSuperview().multipliedBy(0.08) // 수직 스택뷰 높이의 5%로 설정
        }
    }
    

//MARK: -- Action
    @objc func showLocationModal() {
        let locationModalVC = LocationModalViewController(passMode: locationViewMode)
        locationModalVC.modalPresentationStyle = .pageSheet
        locationModalVC.delegate = self
        self.present(locationModalVC, animated: true)
    }
    @objc func voiceModal() {
        let voiceVC = VoiceViewController(passMode: voiceViewMode)
        voiceVC.delegate = self
        self.present(voiceVC, animated: true)
    }
    @objc func weightModal() {
        let weightVC = WeightViewController(passMode: weightViewMode)
        weightVC.delegate = self
        self.present(weightVC, animated: true)
    }
    //이성 결과 넘어가는 viewcontroller 액션
    @objc func navigateToSearchResultViewController(_ sender: Any) {
        preferLocation = locationChoiceLabel.text
        preferVoice = voiceChoiceLabel.text
        let ageLowerBound = Int(ageSlider.lower)
        let ageUpperBound = Int(ageSlider.upper)
        let heightLowerBound = Int(heightSlider.lower)
        let heightUpperBound = Int(heightSlider.upper)
        let searchUserRequest = SearchUserRequest(
                page: 0,
                area: preferLocation,
                vocalRange: preferVoice,
                ageLowerBound: ageLowerBound,
                ageUpperBound: ageUpperBound,
                heightLowerBound: heightLowerBound,
                heightUpperBound: heightUpperBound,
                includePreferredAnimal: isAnimalPreferred
            )
        NetworkService.shared.searchService.searchUser(bodyDTO: searchUserRequest) { response in
            switch response {
            case .success(let data):
                guard let data = data.data else { return }
                print("유저 검색 성공")
            default:
                print("유저 검색 실패")
            }
        }
        let searchResultVC = SearchResultViewController (
            preferLocation: preferLocation ?? "",
            preferVoice: preferVoice ?? "",
            ageRange: "\(ageLowerBound) ~ \(ageUpperBound)세",
            heightRange: "\(heightLowerBound) ~ \(heightUpperBound)cm"
            
        )        
        self.navigationController?.pushViewController(searchResultVC, animated: true)
    }
    @objc func animalButtonTapped() {
        // Toggle the button's selected state
        animalCheckBox.isSelected = !animalCheckBox.isSelected
        
        // Update the image based on the selected state
        let imageName = animalCheckBox.isSelected ? "pinkcheckbox" : "checkbox"
        animalCheckBox.setImage(UIImage(named: imageName), for: .normal)
        
        // Update the property based on the selected state
        isAnimalPreferred = animalCheckBox.isSelected
    }
    @objc func ageChangeValue() {
        self.ageRangeLabel.text = "\(Int(self.ageSlider.lower)) ~ \(Int(self.ageSlider.upper))세"
        self.ageSelectedMode = ageRangeLabel.text
    }
    @objc func heightChangeValue() {
        self.heightRangeLabel.text = "\(Int(self.heightSlider.lower)) ~ \(Int(self.heightSlider.upper))cm"
        self.heightSelectedMode = heightRangeLabel.text
    }
    

}
//MARK: -- 지역 delegate
extension SearchViewController: LocationViewControllerDelegate {
    func locationSelectedRowAt(indexPath: Int) {
        guard let mode = LocationMode(rawValue: indexPath) else { return }
        locationViewMode = mode
        locationChoiceLabel.text = mode.title // 라벨 텍스트 변경
        
    }
}
//MARK: -- 음성 delegate
extension SearchViewController: VoiceViewControllerDelegate {
    func voiceSelectedRowAt(indexPath: Int) {
        guard let mode = VoiceMode(rawValue: indexPath) else { return }
        voiceViewMode = mode
        voiceChoiceLabel.text = mode.title // 라벨 텍스트 변경
        
    }
}
//MARK: -- 체중 delegate
extension SearchViewController: WeightViewControllerDelegate {
    func weightSelectedRowAt(indexPath: Int) {
        guard let mode = WeightMode(rawValue: indexPath) else { return }
        weightViewMode = mode
        weightChoiceLabel.text = mode.title
        
    }
}

