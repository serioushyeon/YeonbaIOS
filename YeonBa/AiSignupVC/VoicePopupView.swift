import UIKit
import SnapKit
import Then
import SwiftKeychainWrapper
import Alamofire
class VoicePopupView: UIView {
    var onDoneButtonTapped: (() -> Void)?
    
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.pretendardBold(size: 26)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let descLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.pretendardMedium(size: 18)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let doneBtn = ActualGradientButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    }
    var navigation : UINavigationController?
    // 이미지 다운로드 및 Data로 변환하는 함수
    func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        AF.download(url).responseData { response in
            guard let data = response.value else {
                completion(nil)
                return
            }
            completion(data)
        }
    }
    
    // MARK: - Actions
    @objc func doneTapped() {
        let selectVC = PhotoSelectionViewController()
        navigation?.pushViewController(selectVC, animated: true)
        let dataManager = SignDataManager.shared
        let imageURLString = "https://newsimg.sedaily.com/2023/09/12/29UNLQFQT6_1.jpg"
        guard let imageURL = URL(string: imageURLString) else {
            print("Invalid image URL")
            return
        }
        
        guard let imageData = try? Data(contentsOf: imageURL) else {
            print("Failed to download image data")
            return
        }
        
        let signUpRequest = SignUpRequest (
            socialId: dataManager.socialId!,
            loginType: dataManager.loginType!,
            gender: dataManager.gender!,
            phoneNumber: dataManager.phoneNumber!,
            birth: dataManager.birthDate!,
            nickname: dataManager.nickName!,
            height: dataManager.height,
            bodyType: dataManager.bodyType!,
            job: dataManager.job!,
            activityArea: dataManager.activityArea!,
            mbti: "estp",
            vocalRange: dataManager.vocalRange!,
            profilePhotos: [imageURLString], // 이미지 데이터 할당
            photoSyncRate: 60,
            lookAlikeAnimal: dataManager.lookAlikeAnimal!,
            preferredAnimal: dataManager.preferredAnimal!,
            preferredArea: dataManager.preferredArea!,
            preferredVocalRange: dataManager.preferredVocalRange!,
            preferredAgeLowerBound: dataManager.preferredAgeLowerBound,
            preferredHeightLowerBound: dataManager.preferredHeightLowerBound!,
            preferredHeightUpperBound: dataManager.preferredHeightUpperBound!,
            preferredBodyType: dataManager.preferredBodyType!,
            preferredMbti: dataManager.preferredMbti!
        )
        
        NetworkService.shared.signUpService.signUp(bodyDTO: signUpRequest) { response in
            switch response {
            case .success(let data):
                guard let data = data.data else { return }
                print("회원가입 성공")
            default:
                print("회원가입 에러")
            }
        }
        
        onDoneButtonTapped?()
    }



    init(title: String, desc: String, navigation: UINavigationController?, leftButtonTitle: String = "취소", rightButtonTitle: String = "완료") {
        self.titleLabel.text = title
        self.descLabel.text = desc
        self.navigation = navigation
        super.init(frame: .zero)
        
        self.backgroundColor = .black.withAlphaComponent(0.3)
        self.addSubview(self.popupView)
        [self.titleLabel, self.descLabel, self.doneBtn]
            .forEach(self.popupView.addSubview(_:))
        
        self.popupView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(353)
        }
        self.titleLabel.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(46)
            make.centerX.equalToSuperview()
        }
        self.descLabel.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
        }
        self.doneBtn.snp.makeConstraints{make in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}
