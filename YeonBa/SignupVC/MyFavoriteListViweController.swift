//
//  MyFavoriteListViweController.swift
//  YeonBa
//
//  Created by jin on 4/10/24.
//
import UIKit
import SnapKit
import Then


class MyFavoriteListViweController: UIViewController {
    let locations = ["서울", "경기도", "인천", "부산", "대전", "광주", "대구", "울산", "강원도", "충북", "충남", "전북", "전남", "경북", "경남", "세종", "제주"]
    private var voiceViewMode: SignVoiceMode = .empty
    private var bodyViewMode: SignWeightMode = .empty
    private var animalViewMode: AnimalMode = .empty
    private var mbtiViewMode: MbtiMode = .empty
    private var locationViewMode: SignLocationMode = .empty
    private var ageViewMode: String = "20~25세"
    // MARK: - UI Components
    let titleLabel = UILabel().then{
        $0.text = "나의 선호조건"
        $0.font = UIFont.pretendardMedium(size: 18)
    }
    let backButton = UIButton(type: .system).then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .light)
        let image = UIImage(named: "back2")
        $0.setImage(image, for: .normal)
        $0.tintColor = UIColor.black
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    let headerLabel = UILabel().then {
        $0.text = "선호하는 조건을 골라 주세요."
        $0.textColor = .black
        $0.font = UIFont.pretendardBold(size: 26)
    }
    let contentLabel = UILabel().then {
        $0.text = "매칭을 위해 필수 단계입니다."
        $0.textColor = .customgray4
        $0.font = UIFont.pretendardMedium(size: 16)
    }
    private let verticalStackview = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .top
        $0.spacing = 10
    }
    
    private let animalView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customgray2?.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let animalLabel = UILabel().then {
        $0.text = "선호하는 동물 상이 어떻게 되세요?"
        $0.textColor = UIColor.gray
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textAlignment = .center
    }
    private let animalChoiceBtn = UIButton().then {
        $0.setImage(UIImage(named: "nextBtn"), for: .normal)
    }
    private let locationView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customgray2?.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let locationLabel = UILabel().then {
        $0.text = "상대방의 선호하는 지역이 어떻게 되세요?"
        $0.textColor = UIColor.gray
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textAlignment = .center
    }
    private let locationChoiceBtn = UIButton().then {
        $0.setImage(UIImage(named: "nextBtn"), for: .normal)
    }
    private let voiceView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customgray2?.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let voiceLabel = UILabel().then {
        $0.text = "선호하는 음역대는 어떻게 되세요?"
        $0.textColor = UIColor.gray
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textAlignment = .center
    }
    private let voiceChoiceBtn = UIButton().then {
        $0.setImage(UIImage(named: "nextBtn"), for: .normal)
    }
    private let ageView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customgray2?.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let ageLabel = UILabel().then {
        $0.text = "선호하는 나이대가 어떻게 되세요?"
        $0.textColor = UIColor.gray
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textAlignment = .center
    }
    private let ageChoiceBtn = UIButton().then {
        $0.setImage(UIImage(named: "nextBtn"), for: .normal)
    }
    private let bodyView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customgray2?.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let bodyLabel = UILabel().then {
        $0.text = "선호하는 체형이 어떻게 되세요?"
        $0.textColor = UIColor.gray
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textAlignment = .center
    }
    private let bodyChoiceBtn = UIButton().then {
        $0.setImage(UIImage(named: "nextBtn"), for: .normal)
    }
    private let mbtiView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customgray2?.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let mbtiLabel = UILabel().then {
        $0.text = "선호하는 MBTI가 어떻게 되세요?"
        $0.textColor = UIColor.gray
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textAlignment = .center
    }
    private let mbtiChoiceBtn = UIButton().then {
        $0.setImage(UIImage(named: "nextBtn"), for: .normal)
    }

    let nextButton = ActualGradientButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        configUI()
        tapGesture()
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(headerLabel)
        view.addSubview(contentLabel)
        view.addSubview(nextButton)
        view.addSubview(verticalStackview)
        verticalStackview.addArrangedSubview(animalView)
        animalView.addSubview(animalLabel)
        animalView.addSubview(animalChoiceBtn)
        verticalStackview.addArrangedSubview(locationView)
        locationView.addSubview(locationLabel)
        locationView.addSubview(locationChoiceBtn)
        verticalStackview.addArrangedSubview(voiceView)
        voiceView.addSubview(voiceLabel)
        voiceView.addSubview(voiceChoiceBtn)
        verticalStackview.addArrangedSubview(ageView)
        ageView.addSubview(ageLabel)
        ageView.addSubview(ageChoiceBtn)
        verticalStackview.addArrangedSubview(bodyView)
        bodyView.addSubview(bodyLabel)
        bodyView.addSubview(bodyChoiceBtn)
        verticalStackview.addArrangedSubview(mbtiView)
        mbtiView.addSubview(mbtiLabel)
        mbtiView.addSubview(mbtiChoiceBtn)
    }
    func configUI() {
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55)
            make.leading.equalToSuperview().offset(21)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55)
            make.centerX.equalToSuperview()
        }
        
        headerLabel.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(20)
        }
        contentLabel.snp.makeConstraints{make in
            make.top.equalTo(headerLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(20)
        }
        verticalStackview.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        animalView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview()
        }
        animalLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        animalChoiceBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
        }
        locationView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview()
        }
        locationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        locationChoiceBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
        }
        voiceView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview()
        }
        voiceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        voiceChoiceBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
        }
        ageView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview()
        }
        ageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        ageChoiceBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
        }
        bodyView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview()
        }
        bodyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        bodyChoiceBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
        }
        mbtiView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview()
        }
        mbtiLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        mbtiChoiceBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
        }
        nextButton.snp.makeConstraints{make in
            make.bottom.equalToSuperview().offset(-55)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(56)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    func tapGesture() {
        animalView.isUserInteractionEnabled = true
        let animalGesture = UITapGestureRecognizer(target: self, action: #selector(showAnimalModal))
        animalView.addGestureRecognizer(animalGesture)
        
        locationView.isUserInteractionEnabled = true
        let locationGesture = UITapGestureRecognizer(target: self, action: #selector(showLocationModal))
        locationView.addGestureRecognizer(locationGesture)
        
        voiceView.isUserInteractionEnabled = true
        let voiceGesture = UITapGestureRecognizer(target: self, action: #selector(showVoiceModal))
        voiceView.addGestureRecognizer(voiceGesture)
        
        ageView.isUserInteractionEnabled = true
        let ageGesture = UITapGestureRecognizer(target: self, action: #selector(showAgeModal))
        ageView.addGestureRecognizer(ageGesture)
        
        bodyView.isUserInteractionEnabled = true
        let bodyGesture = UITapGestureRecognizer(target: self, action: #selector(showBodyModal))
        bodyView.addGestureRecognizer(bodyGesture)
        
        mbtiView.isUserInteractionEnabled = true
        let mbtiGesture = UITapGestureRecognizer(target: self, action: #selector(showMbtiModal))
        mbtiView.addGestureRecognizer(mbtiGesture)
    }
    //MARK: - Actions
    @objc func backButtonTapped() {
        // 뒤로 가기 로직을 구현
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextButtonTapped() {
        // Validate the nickname and if valid, proceed to the next screen
        let nextVC = VoiceRecordingViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func showLocationModal() {
        let locationModalVC = FavoriteLocationViewController(passMode: locationViewMode)
        locationModalVC.modalPresentationStyle = .pageSheet
        locationModalVC.delegate = self
        self.present(locationModalVC, animated: true)
    }
    @objc func showVoiceModal() {
        let voiceVC = FavoriteVoiceViewController(passMode: voiceViewMode)
        voiceVC.delegate = self
        self.present(voiceVC, animated: true)
    }
    @objc func showBodyModal() {
        let bodyVC = FavoriteBodyViewController(passMode: bodyViewMode)
        bodyVC.delegate = self
        self.present(bodyVC, animated: true)
    }
    @objc func showAnimalModal() {
        let animalVC = FavoriteAnimalViewController(passMode: animalViewMode)
        animalVC.delegate = self
        self.present(animalVC, animated: true)
    }
    @objc func showMbtiModal() {
        let mbtiVC = FavoriteMbtiViewController(passMode: mbtiViewMode)
        mbtiVC.delegate = self
        self.present(mbtiVC, animated: true)
    }
    @objc func showAgeModal() {
        let ageVC = FavoriteAgeViewController(passMode: ageViewMode)
        ageVC.delegate = self
        self.present(ageVC, animated: true)
    }
}
//MARK: -- 지역 delegate
extension MyFavoriteListViweController: FavoriteLocationViewControllerDelegate {
    func locationSelectedRowAt(indexPath: Int) {
        guard let mode = SignLocationMode(rawValue: indexPath) else { return }
        locationViewMode = mode
        locationLabel.text = mode.title // 라벨 텍스트 변경
    }
}
//MARK: -- 음성 delegate
extension MyFavoriteListViweController: FavoriteVoiceViewControllerDelegate {
    func voiceSelectedRowAt(indexPath: Int) {
        guard let mode = SignVoiceMode(rawValue: indexPath) else { return }
        
        voiceViewMode = mode
        voiceLabel.text = mode.title // 라벨 텍스트 변경
    }
}
//MARK: -- 체중 delegate
extension MyFavoriteListViweController: FavoriteBodyDelegate {
    func weightSelectedRowAt(indexPath: Int) {
        guard let mode = SignWeightMode(rawValue: indexPath) else { return }
        
        bodyViewMode = mode
        bodyLabel.text = mode.title // 라벨 텍스트 변경
    }
}
//MARK: -- 동물상 delegate
extension MyFavoriteListViweController: FavoriteAnimalViewControllerDelegate {
    func animalSelected(_ mode: AnimalMode) {
        animalViewMode = mode
        animalLabel.text = mode.title // 라벨 텍스트 변경
    }
}
//MARK: -- mbti delegate
extension MyFavoriteListViweController: FavoriteMbtiViewControllerDelegate {
    func mbtiSelected(_ mode: MbtiMode) {
        mbtiViewMode = mode
        mbtiLabel.text = mode.title // 라벨 텍스트 변경
    }
}
//MARK: -- age delegate
extension MyFavoriteListViweController: FavoriteAgeViewControllerDelegate {
    func ageSelected(_ mode: String) {
        ageLabel.text = mode // 라벨 텍스트 변경
    }
    
}
