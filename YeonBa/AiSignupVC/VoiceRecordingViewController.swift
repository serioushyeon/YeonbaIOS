//
//  VoiceRecordingViewController.swift
//  YeonBa
//
//  Created by jin on 3/6/24.
//

import UIKit
import AVFoundation

class VoiceRecordingViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: - UI Components
    let titleLabel = UILabel().then{
        $0.text = "AI 음역대 측정"
        $0.font = UIFont.pretendardMedium(size: 18)
    }
    let backButton = UIButton(type: .system).then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .light)
        let image = UIImage(named: "BackButton")
        $0.setImage(image, for: .normal)
        $0.tintColor = UIColor.black
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    let recordingIndicatorView = UIView().then {
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 5
    }
    
    let recordingLabel = UILabel().then {
        $0.text = "녹음 중.."
        $0.font = UIFont.pretendardMedium(size: 18)
    }
    
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 79.5
        $0.layer.borderWidth = 4
        $0.layer.borderColor = UIColor.white.cgColor
        $0.clipsToBounds = true
    }
    
    let profileImageBGView = UIImageView().then {
        $0.layer.cornerRadius = 87.5
        $0.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 175, height: 175)
        gradientLayer.colors = [UIColor(hex: "FF8F96").cgColor, UIColor(hex: "FF2149").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        // 이미지뷰의 배경으로 그라데이션 적용
        $0.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    let instructionLabel = UILabel().then {
        $0.text = "연바에게 목소리를 들려주세요!"
        $0.font = UIFont.pretendardBold(size: 26)
        $0.textAlignment = .center
    }
    
    let detailLabel = UILabel().then {
        $0.text = "녹음한 목소리로 음역대를 측정해 드려요."
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textAlignment = .center
        $0.textColor = .gray
    }
    
    let recordingTimeLabel = UILabel().then {
        $0.text = "00:11"
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textAlignment = .center
    }
    
    let recordButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .light)
        let image = UIImage(systemName: "mic.circle.fill", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = UIColor.primary
        $0.layer.cornerRadius = 33.5
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor(hex: "FF2149").cgColor
        $0.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
    }
    
    var audioRecorder: AVAudioRecorder?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubViews()
        configUI()
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationItem.hidesBackButton = true
    }
    
    // MARK: - Setup
    func setupUI() {
        setupBGColor()
        setupRecording()
    }
    
    // MARK: - UI Layout
    func addSubViews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(recordingIndicatorView)
        view.addSubview(recordingLabel)
        view.addSubview(profileImageBGView)
        view.addSubview(profileImageView)
        view.addSubview(instructionLabel)
        view.addSubview(detailLabel)
        view.addSubview(recordingTimeLabel)
        view.addSubview(recordButton)
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
        
        recordingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(171)
            make.centerX.equalToSuperview()
        }
        
        recordingIndicatorView.snp.makeConstraints { make in
            make.centerY.equalTo(recordingLabel.snp.centerY)
            make.trailing.equalTo(recordingLabel.snp.leading).offset(-4)
            make.width.height.equalTo(10)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(218)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(159)
        }
        
        profileImageBGView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(209)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(175)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        
        recordingTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
        }
        
        recordButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-55)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(67)
        }
        
        
    }
    func setupBGColor() {
        let gradientLayer = CAGradientLayer()
        
        // 그라데이션 레이어 크기 설정
        gradientLayer.frame = self.view.bounds
        
        // 그라데이션 색상 설정 (FFFFFF와 FFE3E3을 CGColor로 변환)
        gradientLayer.colors = [UIColor(hex: "FFFFFF").cgColor, UIColor(hex: "FFE3E3").cgColor]
        
        // 그라데이션 방향 설정 (위에서 아래로)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        // 그라데이션 레이어를 뷰의 백그라운드로 설정
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Actions
    func setupRecording() {
        // 녹음 세션 구성
        let recordingSession = AVAudioSession.sharedInstance()
        try? recordingSession.setCategory(.playAndRecord, mode: .default)
        try? recordingSession.setActive(true)
        
        // 녹음 설정
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        // 오디오 레코더 초기화
        audioRecorder = try? AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder?.delegate = self
    }
    @objc func recordButtonTapped() {
        // 권한
        AVAudioSession.sharedInstance().requestRecordPermission { (accepted) in
            if accepted {
                print("permission granted")
            }
        }
        if let recorder = audioRecorder {
            if recorder.isRecording {
                // 녹음 중지
                recorder.stop()
                let imageConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .light)
                let image = UIImage(systemName: "mic.circle.fill", withConfiguration: imageConfig)
                recordButton.setImage(image, for: .normal)
                recordButton.backgroundColor = .white
                recordButton.tintColor = UIColor.primary
                
                // 여기서 팝업을 띄웁니다.
                presentPopup()
            } else {
                // 녹음 시작
                recorder.record()
                recordButton.backgroundColor = UIColor.clear
                recordButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                recordButton.tintColor = UIColor.primary
            }
        }
    }
    
    func presentPopup() {
        // 팝업 뷰 컨트롤러를 생성하고 모달로 띄웁니다.
        let popupViewController = VoicePopupViewcontroller(title: "연방님은 저음입니다!", desc: "연방님은 저음의 음역대를 가지고 게시군요!\n저음의 목소리를 이성에게 어필해 보세요!", navigation: navigationController)
        popupViewController.modalPresentationStyle = .overFullScreen
        self.present(popupViewController, animated: false)
    }
    
    @objc func backButtonTapped() {
        // 뒤로 가기 로직을 구현
        dismiss(animated: true, completion: nil)
    }
}
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
extension UIFont {
    static func pretendardMedium(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Pretendard-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        return font
    }
    static func pretendardBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Pretendard-Bold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
    static func pretendardExtraBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Pretendard-ExtraBold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
}
