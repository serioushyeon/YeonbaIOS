import UIKit
import SnapKit
import Then
import Kingfisher

class ProfileEditViewController: UIViewController, UIViewControllerTransitioningDelegate, HeightEditViewControllerDelegate,VoiceEditViewControllerDelegate, LivingAreaViewControllerDelegate, BodyEditViewControllerDelegate, FaceEditViewControllerDelegate, MbtiEditViewControllerDelegate, AnimalPreferenceViewControllerDelegate, RegionPreferenceViewControllerDelegate, VoicePreferenceViewControllerDelegate, BodyTypePreferenceViewControllerDelegate, MBTIPreferenceViewControllerDelegate {
    
    var profileDetail = 
    ProfileDetailResponse(profilePhotoUrls: [],
                          gender: "남",
                          birth: "1998-01-01",
                          height: 181,
                          phoneNumber: "01011112222",
                          nickname: "존잘남",
                          photoSyncRate: 80,
                          bodyType: "마른 체형",
                          job: "학생",
                          mbti: "ISTP",
                          vocalRange : "고음",
                          lookAlikeAnimal: "고양이상", 
                          activityArea: "서울", 
                          preferredVocalRange: "중음",
                          preferredAnimal: "강아지상",
                          preferredArea: "경기",
                          preferredAgeLowerBound: 35,
                          preferredAgeUpperBound: 40,
                          preferredHeightLowerBound: 170,
                          preferredHeightUpperBound: 180,
                          preferredMbti: "ISTJ",
                          preferredBodyType: "마른체형")
    
    var profileEdit = ProfileEditRequest(nickname:"", height: 160, vocalRange: "중음", birth: "2000-12-17", bodyType: "마른체형", job: "직장인", activityArea: "서울", lookAlikeAnimal: "강아지상", mbti: "INTJ", preferredAnimal: "강아지상", preferredArea: "서울", preferredVocalRange: "저음", preferredAgeLowerBound: 22, preferredAgeUpperBound: 24, preferredHeightLowerBound: 181, preferredHeightUpperBound: 185, preferredBodyType: "보통체형", preferredMbti: "INTP")
    
    //about me
    func didSelectHeight(_ height: Int) {
        let heightButton = infoFields[0]
        heightButton.setTitle("\(height)cm", for: .normal)
        profileEdit.height = height
    }

    func voiceSelected(_ voiceType: String) {
        let voiceButton = infoFields[1]
        voiceButton.setTitle(voiceType, for: .normal)
        profileEdit.vocalRange = voiceType
    }
    
    func didSelectLivingArea(_ area: String) {
        let areaButton = infoFields[2]
        areaButton.setTitle(area, for: .normal)
        profileEdit.activityArea = area
    }
    
    func didSelectBodyType(_ type: String) {
        let bodyButton = infoFields[3]
        bodyButton.setTitle(type, for: .normal)
        profileEdit.bodyType = type
    }
    
    func didSelectFaceType(_ type: String) {
        let faceTypeButton = infoFields[4]
        faceTypeButton.setTitle(type, for: .normal)
        profileEdit.lookAlikeAnimal = type
    }
    
    func didSelectMBTI(_ type: String) {
        let mbtiButton = infoFields[5]
        mbtiButton.setTitle(type, for: .normal)
        profileEdit.mbti = type
    }
    
    //preference
    func didSelectFaceType1(_ type: String) {
        let faceTypeButton = preferenceFields[0]
        faceTypeButton.setTitle(type, for: .normal)
        profileEdit.preferredAnimal = type
    }
    
    func didSelectRegionPreference(_ area: String) {
        let areaButton = preferenceFields[1]
        areaButton.setTitle(area, for: .normal)
        profileEdit.preferredArea = area
    }
    
    func voicePreferenceSelected(_ voiceType: String) {
        let voiceButton = preferenceFields[2]
        voiceButton.setTitle(voiceType, for: .normal)
        profileEdit.preferredVocalRange = voiceType
    }
    
    func didSelectBodyType1(_ type: String) {
        let bodyButton = preferenceFields[4]
        bodyButton.setTitle(type, for: .normal)
        profileEdit.preferredBodyType = type
    }
    
    func didSelectMBTI1(_ type: String) {
        let mbtiButton = preferenceFields[5]
        mbtiButton.setTitle(type, for: .normal)
        profileEdit.preferredMbti = type
    }
    
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let photoSectionLabel = UILabel().then {
        $0.text = "최소 2장의 사진을 등록해주세요."
        $0.font = UIFont.pretendardRegular(size: 14)
        $0.textColor = .black
    }

    private let photoScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }

    private let photoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }

    let addPhotoImageView1 = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.setImage(UIImage(named: "Addpicture"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(photoTapped), for: .touchUpInside)
    }
    
    let addPhotoImageView2 = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.setImage(UIImage(named: "Addpicture"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(photoTapped), for: .touchUpInside)
    }

    private let aboutMeLabel = UILabel().then {
        $0.text = "About Me"
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }

    private var infoFieldTitles = ["키", "목소리", "사는 지역", "체형", "얼굴상", "MBTI"]
    private var infoFields: [UIButton] = []


    private let preferenceLabel = UILabel().then {
        $0.text = "Preference"
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }
    func updatePhotos() {
        addPhotoImageView1.setImage(SignDataManager.shared.placeholderImage, for: .normal)
        addPhotoImageView2.setImage(SignDataManager.shared.essentialImage, for: .normal)
    }
    // URL에서 UIImage를 생성하는 함수
    func loadImageFromURL(url: URL) -> UIImage? {
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print("Failed to load image from URL:", error.localizedDescription)
            return nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = false
        setupNavigationBar()
        setupNavigationBarButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 사용 예시
        if let imageURL = URL(string: Config.s3URLPrefix + profileDetail.profilePhotoUrls[0]) {
            if let image = loadImageFromURL(url: imageURL) {
                let resizedImage = image.resizeImage(image: image, newWidth: 200) // 폭이 200인 이미지로 리사이징
                    
                addPhotoImageView1.setImage(resizedImage, for: .normal)
            } else {
                // 이미지 로드 실패
                print("Failed to load image")
            }
        } else {
            print("Invalid URL")
        }
        if let imageURL = URL(string: Config.s3URLPrefix + profileDetail.profilePhotoUrls[1]) {
            if let image = loadImageFromURL(url: imageURL) {
                let resizedImage = image.resizeImage(image: image, newWidth: 200) // 폭이 200인 이미지로 리사이징
                    
                addPhotoImageView2.setImage(resizedImage, for: .normal)
            } else {
                // 이미지 로드 실패
                print("Failed to load image")
            }
        } else {
            print("Invalid URL")
        }
        setupLayout()
        setupNavigationBar()
        setupInfoFields()  // 정보 필드 설정
        setupPreferenceFields()
        configurePhotoPicker()  // 사진 선택기 구성
        setupContentLayout()  // 컨텐츠 레이아웃 구성
        setupNavigationBarButton()
    }


    private func setupInfoFields() {
        infoFieldTitles = ["\(profileDetail.height)cm", profileDetail.vocalRange, profileDetail.activityArea, profileDetail.bodyType, profileDetail.lookAlikeAnimal, profileDetail.mbti]
        profileEdit.nickname = profileDetail.nickname
        profileEdit.birth = profileDetail.birth
        profileEdit.job = profileDetail.job
        profileEdit.height = profileDetail.height
        profileEdit.vocalRange = profileDetail.vocalRange
        profileEdit.activityArea = profileDetail.activityArea
        profileEdit.bodyType = profileDetail.bodyType
        profileEdit.lookAlikeAnimal = profileDetail.lookAlikeAnimal
        profileEdit.mbti = profileDetail.mbti
        
        infoFields = infoFieldTitles.enumerated().map { index, title in
            let button = UIButton().then {
                $0.setTitle(title, for: .normal)
                $0.backgroundColor = .white
                $0.layer.borderColor = UIColor.gray.cgColor
                $0.layer.borderWidth = 1
                $0.layer.cornerRadius = 8
                $0.setTitleColor(.black, for: .normal)
                $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
                $0.snp.makeConstraints { make in
                    make.height.equalTo(51)
                }
                $0.tag = index // Assign a unique tag
                $0.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
            }
            return button
        }
    }

    

    @objc private func infoButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let heightEditVC = HeightEditViewController()
            heightEditVC.delegate = self
            heightEditVC.modalPresentationStyle = .pageSheet
            present(heightEditVC, animated: true)
        case 1:
            let voiceEditVC = VoiceEditViewController()
            voiceEditVC.delegate = self
            voiceEditVC.modalPresentationStyle = .pageSheet
            present(voiceEditVC, animated: true)
        case 2:
            let livingareaEditVC = LivingAreaViewController()
            livingareaEditVC.delegate = self
            livingareaEditVC.modalPresentationStyle = .pageSheet
            present(livingareaEditVC, animated: true)
        case 3:
            let bodyEditVC = BodyEditViewController()
            bodyEditVC.delegate = self
            bodyEditVC.modalPresentationStyle = .pageSheet
            present(bodyEditVC, animated: true)
        case 4:
            let faceEditVC = FaceEditViewController()
            faceEditVC.delegate = self
            faceEditVC.modalPresentationStyle = .pageSheet
            present(faceEditVC, animated: true)
        case 5:
            let mbtiEditVC = MbtiEditViewController()
            mbtiEditVC.delegate = self
            mbtiEditVC.modalPresentationStyle = .pageSheet
            present(mbtiEditVC, animated: true)
        default:
            break
        }
    }
    private var preferenceFieldstitle = ["선호하는 얼굴상", "선호하는 지역", "선호하는 목소리", "선호하는 나이대", "선호하는 체형", "선호하는 MBTI"]
    private var preferenceFields: [UIButton] = []
    private func setupPreferenceFields() {
        preferenceFieldstitle = [profileDetail.preferredAnimal,
                                profileDetail.preferredArea,
                                profileDetail.preferredVocalRange,
                                "선호하는 나이대",
                                profileDetail.preferredBodyType,
                                profileDetail.preferredMbti]
        profileEdit.preferredAnimal = profileDetail.preferredAnimal
        profileEdit.preferredArea = profileDetail.preferredArea
        profileEdit.preferredVocalRange = profileDetail.preferredVocalRange
        profileEdit.preferredBodyType = profileDetail.preferredBodyType
        profileEdit.preferredMbti = profileDetail.preferredMbti
        profileEdit.preferredAgeLowerBound = profileDetail.preferredAgeLowerBound
        profileEdit.preferredAgeUpperBound = profileDetail.preferredAgeUpperBound
        profileEdit.preferredHeightLowerBound = profileDetail.preferredHeightLowerBound
        profileEdit.preferredHeightUpperBound = profileDetail.preferredHeightUpperBound
                    
        preferenceFields = preferenceFieldstitle.enumerated().map { index, title in
            let button = UIButton().then {
                $0.setTitle(title, for: .normal)
                $0.backgroundColor = .white
                $0.layer.borderColor = UIColor.gray.cgColor
                $0.layer.borderWidth = 1
                $0.layer.cornerRadius = 8
                $0.setTitleColor(.black, for: .normal)
                $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
                $0.snp.makeConstraints { make in
                    make.height.equalTo(51)
                }
                $0.tag = index + 100 // Assign a unique tag, ensuring it's different from infoFields tags
                $0.addTarget(self, action: #selector(preferenceButtonTapped(_:)), for: .touchUpInside)
            }
            return button
        }
    }

    @objc private func preferenceButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            let animalPreferenceVC = AnimalPreferenceViewController()
            animalPreferenceVC.delegate = self
            animalPreferenceVC.modalPresentationStyle = .pageSheet
            present(animalPreferenceVC, animated: true)
        case 101:
            let regionPreferenceVC = RegionPreferenceViewController()
            regionPreferenceVC.delegate = self
            regionPreferenceVC.modalPresentationStyle = .pageSheet
            present(regionPreferenceVC, animated: true)
        case 102:
            let voicePreferenceVC = VoicePreferenceViewController()
            voicePreferenceVC.delegate = self
            voicePreferenceVC.modalPresentationStyle = .pageSheet
            present(voicePreferenceVC, animated: true)
        case 104:
            let bodyTypePreferenceVC = BodyTypePreferenceViewController()
            bodyTypePreferenceVC.delegate = self
            bodyTypePreferenceVC.modalPresentationStyle = .pageSheet
            present(bodyTypePreferenceVC, animated: true)
        case 105:
            let MBTIPreferenceVC = MBTIPreferenceViewController()
            MBTIPreferenceVC.delegate = self
            MBTIPreferenceVC.modalPresentationStyle = .pageSheet
            present(MBTIPreferenceVC, animated: true)
        default:
            break
        }
    }

    private func navigateToViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }

    
    private func setupNavigationBar() {
        navigationItem.title = "프로필 수정"
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }

        setupContentLayout()
    }

        
    private func setupContentLayout() {
        // 스택 뷰 생성 및 설정
        let stackView = UIStackView(arrangedSubviews: [
            photoSectionLabel,
            photoScrollView,
            aboutMeLabel
        ] + infoFields + [
            preferenceLabel
        ] + preferenceFields)

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    private func configurePhotoPicker() {
        contentView.addSubview(photoScrollView)
        photoScrollView.addSubview(photoStackView)

        photoScrollView.snp.makeConstraints { make in
            make.top.equalTo(photoSectionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        photoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(photoScrollView)
        }
        photoStackView.addArrangedSubview(addPhotoImageView1)
        addPhotoImageView1.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 150, height: 150))
        }
        photoStackView.addArrangedSubview(addPhotoImageView2)
        addPhotoImageView2.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 150, height: 150))
        }
    }
    
    private func setupNavigationBarButton() {
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.setTitleTextAttributes([.foregroundColor: UIColor.primary, .font: UIFont.pretendardMedium(size: 19)], for: .normal)
        navigationItem.rightBarButtonItem = doneButton
    }
    func apiEditProfile(){
        let editRequest = self.profileEdit
        NetworkService.shared.mypageService.editProfile(bodyDTO: editRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                print("수정 성공")
            default:
                print("수정 실패")
                
            }
        }
    }
    @objc private func doneButtonTapped() {
        print("완료 버튼이 눌렸습니다.")
        print(self.profileEdit)
        apiEditProfile()
        navigationController?.popViewController(animated: true)
    }
    @objc func photoTapped() {
        let selectVC = ProfilePhotoEditViewController()
        navigationController?.pushViewController(selectVC, animated: false)
    }
}


