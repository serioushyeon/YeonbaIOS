//
//  EditSimilarityResultViewController.swift
//  YeonBa
//
//  Created by jin on 5/30/24.
//


import UIKit
import SnapKit
import Then
import Alamofire

class EditSimilarityResultViewController: UIViewController {
    
    var confidence1 = 0.0
    var confidence2 = 0.0
    
    // MARK: - UI Components
    let selfieImage = UIImageView().then{
        $0.image = SignDataManager.shared.selfieImage
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    let profileImage1 = UIImageView().then{
        $0.image = SignDataManager.shared.essentialImage
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    let profileImage2 = UIImageView().then{
        $0.image = SignDataManager.shared.placeholderImage
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    let text1 = UILabel().then{
        $0.text = "연방님의 유사도는"
        $0.font = UIFont.pretendardExtraBold(size: 32)
        $0.textColor = .black // 검정색으로 설정
    }
    let text2 = UILabel().then{
        $0.text = "40%에요!"
        $0.font = UIFont.pretendardExtraBold(size: 32)
        $0.textColor = .black // 검정색으로 설정
    }
    let explainText = UILabel().then{
        $0.text = "업로드한 사진과 실제 얼굴이 달라요\nAI 포토샵으로 유사도를 높일 수 있어요!"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textColor = UIColor.gray
    }
    
    let selfieBtn = ActualGradientButton().then {
        $0.setTitle("재업로드 하기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(reSelfieBtnTapped), for: .touchUpInside)
    }
    let aiBtn = ActualGradientButton().then {
        $0.setTitle("AI 포토샵 하러가기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(aiBtnTapped), for: .touchUpInside)
    }
    
    let startBtn = ActualGradientButton().then {
        $0.setTitle("프로필 사진 수정", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(startBtnTapped), for: .touchUpInside)
    }
    
    // 로딩 인디케이터 추가
    let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.color = .gray
        $0.hidesWhenStopped = true
    }
    
    // MARK: - Actions
    @objc func aiBtnTapped() {
        let aiVC = AiPhotoshopViewController()
        navigationController?.pushViewController(aiVC, animated: true)
    }
    @objc func reSelfieBtnTapped() {
        if let navController = navigationController {
            for controller in navController.viewControllers {
                if let photoSelectionVC = controller as? ProfilePhotoEditViewController {
                    navController.popToViewController(photoSelectionVC, animated: true)
                    return
                }
            }
        }
    }
    func apiEditPhoto(){
        let editRequest = PhotoEditRequest(profilePhotos: SignDataManager.shared.profilePhotos!, photoSyncRate: SignDataManager.shared.confidence!)
        NetworkService.shared.mypageService.editPhoto(bodyDTO: editRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                print("수정 성공")
            default:
                print("수정 실패")
            }
        }
    }
    @objc func startBtnTapped() {
        if let navController = navigationController {
            for controller in navController.viewControllers {
                if let photoSelectionVC = controller as? ProfileEditViewController {
                    apiEditPhoto()
                    photoSelectionVC.updatePhotos()
                    navController.popToViewController(photoSelectionVC, animated: true)
                    return
                }
            }
        }
    }
    @objc func backButtonTapped() {
        // 뒤로 가기 로직을 구현
        dismiss(animated: true, completion: nil)
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        profileImage1.image = SignDataManager.shared.placeholderImage
        profileImage2.image = SignDataManager.shared.essentialImage
        
        // 로딩 인디케이터 추가
        addSubViews()
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        
        // Create a dispatch group
        let dispatchGroup = DispatchGroup()
        
        // Enter the group before starting the first API request
        dispatchGroup.enter()
        
        // Start the first API request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.apiSimilarity(upload: SignDataManager.shared.essentialImage, real: SignDataManager.shared.selfieImage) { confidence in
                // Leave the group when the first API request is completed
                dispatchGroup.leave()
                self.confidence1 = confidence
            }
        }
        
        // Start the second API request after the first one is completed
        dispatchGroup.notify(queue: .main) {
            self.apiSimilarity(upload: SignDataManager.shared.placeholderImage, real: SignDataManager.shared.selfieImage) {confidence in
                self.confidence2 = confidence
                self.loadingIndicator.stopAnimating() // 로딩 인디케이터 숨김
                self.configUI()
                var confidence = Int((self.confidence1 + self.confidence2) / 2)
                self.text2.text = "\(confidence)%에요!"
                if(confidence <= 75)
                {
                    self.explainText.text = "업로드한 사진과 실제 얼굴이 달라요\n사진을 다시 업로드할 수 있어요!"
                    self.startBtn.isHidden = true
                }
                else{
                    SignDataManager.shared.confidence = confidence
                    self.explainText.text = "버튼을 눌러 프로필 사진 수정을 완료할 수 있어요! "
                    self.selfieBtn.isHidden = true
                    self.aiBtn.isHidden = true
                }
                let fullText = self.text2.text ?? ""
                let attribtuedString = NSMutableAttributedString(string: fullText)
                let range = (fullText as NSString).range(of: "\(confidence)%")
                attribtuedString.addAttribute(.foregroundColor, value: UIColor.primary, range: range)
                self.text2.attributedText = attribtuedString
            }
        }
    }
    
    // MARK: Select RootViewController Function
    func changeRootViewController(rootViewController: UIViewController) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        sceneDelegate.window?.rootViewController = BaseNavigationController(rootViewController: rootViewController)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func apiSimilarity(upload: UIImage, real: UIImage, completion: @escaping (Double) -> Void) {
        // Load images to compare
        let image1 = upload
        let image2 = real
        
        // Convert images to Data
        guard let imageData1 = image1.jpegData(compressionQuality: 1.0),
              let imageData2 = image2.jpegData(compressionQuality: 1.0) else {
            fatalError("Failed to convert images to data")
        }
        
        let url = "https://api-us.faceplusplus.com/facepp/v3/compare"
        let parameters: Parameters = [
            "api_key": "WC0CaE1oGhbR06_-SePXVM-iKQq0BCkT",
            "api_secret": "48cmzpAX4bUENmwbvKbBB_dNU4d-MdqV"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            // Add images to multipart form data
            multipartFormData.append(imageData1, withName: "image_file1", fileName: "uploadSelfie.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(imageData2, withName: "image_file2", fileName: "realSelfie.jpeg", mimeType: "image/jpeg")
            
            // Add other parameters to multipart form data
            for (key, value) in parameters {
                if let data = String(describing: value).data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: url)
        .validate(statusCode: 200..<500)
        .responseJSON() { response in
            print(response)
        }
        .responseDecodable(of: FaceComparisonResult.self) { response in
            switch response.result {
                // [CASE] API 통신에 성공한 경우
            case .success(let value):
                print("성공하였습니다 :: \(value)")
                completion(value.confidence!)
                
                // [CASE] API 통신에 실패한 경우
            case .failure(let error):
                print("실패하였습니다 :: \(error)" )
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationItem.hidesBackButton = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    // MARK: - UI Layout
    func configUI() {
        selfieImage.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(100)
            make.right.equalTo(view.snp.centerX).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
            make.height.equalTo(314)
            
        }
        
        profileImage1.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(100)
            make.left.equalTo(selfieImage.snp.right).offset(10)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(152)
            
        }
        profileImage2.snp.makeConstraints{ make in
            make.top.equalTo(profileImage1.snp.bottom).offset(10)
            make.left.equalTo(selfieImage.snp.right).offset(10)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(152)
            
        }
        text1.snp.makeConstraints{ make in
            make.top.equalTo(selfieImage.snp.bottom).offset(69)
            make.centerX.equalToSuperview()
        }
        text2.snp.makeConstraints{ make in
            make.top.equalTo(text1.snp.bottom).offset(5.75)
            make.centerX.equalToSuperview()
            
        }
        explainText.snp.makeConstraints{ make in
            make.top.equalTo(text2.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            
        }
        selfieBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-55)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(56)
        }
        //유사도 높으면 바로 시작
        startBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-55)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(56)
        }

        
    }
    
    func addSubViews() {
        view.addSubview(selfieImage)
        view.addSubview(profileImage1)
        view.addSubview(profileImage2)
        view.addSubview(text1)
        view.addSubview(text2)
        view.addSubview(explainText)
        view.addSubview(selfieBtn)
        //유사도 높으면 시작 버튼
        view.addSubview(startBtn)
    }
}
