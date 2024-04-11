import UIKit
import SnapKit
import Then
import Alamofire

class PhoneNumberViewController: UIViewController {
    
    var timer: Timer?
    var timeRemaining = 300
    let instructionLabel = UILabel().then {
        $0.text = "전화번호를 입력해주세요."
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .pretendardBold(size: 26)
        $0.numberOfLines = 0
    }
    
    let instructionLabel2 = UILabel().then {
        $0.text = "가입여부에만 활용되며, 절대 노출되지 않아요."
        $0.textColor = .customgray3
        $0.textAlignment = .center
        $0.font = .pretendardMedium(size: 16)
        $0.numberOfLines = 0
    }
    
    
    let phoneNumberUnderlineView = UIView().then {
        $0.backgroundColor = .gray
    }
    
    let verificationCodeUnderlineView = UIView().then {
        $0.backgroundColor = .gray
    }
    
    let phoneNumberTextField = UITextField().then {
        $0.placeholder = "전화번호 입력"
        $0.keyboardType = .phonePad
        $0.borderStyle = .roundedRect
        $0.textAlignment = .center
        $0.keyboardType = .numberPad
        
    }
    
    let sendCodeButton = UIButton().then {
        $0.setTitle("전송", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.addTarget(self, action: #selector(sendCodeButtonTapped), for: .touchUpInside)
    }
    
    let verificationCodeTextField = UITextField().then {
        $0.placeholder = "인증번호 입력"
        $0.keyboardType = .numberPad
        $0.borderStyle = .roundedRect
        $0.textAlignment = .center
    }
    
    let confirmButton = UIButton().then {
        $0.setTitle("인증", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    let timerLabel = UILabel().then {
        $0.text = "2:57"
        $0.textAlignment = .center
        $0.textColor = .gray
    }
    let nextButton = ActualGradientButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .systemGray
        $0.layer.cornerRadius = 30
        $0.isEnabled = false // 인증 완료 전까지 비활성화
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        
    }
    
    private func setupViews() {
        view.addSubview(instructionLabel)
        view.addSubview(instructionLabel2)
        view.addSubview(phoneNumberUnderlineView)
        view.addSubview(verificationCodeUnderlineView)
        view.addSubview(phoneNumberTextField)
        view.addSubview(sendCodeButton)
        view.addSubview(verificationCodeTextField)
        view.addSubview(confirmButton)
        view.addSubview(nextButton)
        view.addSubview(timerLabel)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalToSuperview().inset(20)
        }
        
        instructionLabel2.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        
        phoneNumberTextField.borderStyle = .none
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel2.snp.top).offset(100)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        phoneNumberUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom)
            make.leading.trailing.equalTo(phoneNumberTextField)
            make.height.equalTo(1)
        }
        
        sendCodeButton.snp.remakeConstraints { make in
            make.centerY.equalTo(phoneNumberTextField)
            make.leading.equalTo(phoneNumberTextField.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.height.equalTo(phoneNumberTextField.snp.height)
        }
        
        verificationCodeTextField.borderStyle = .none
        verificationCodeTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberUnderlineView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        verificationCodeUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(verificationCodeTextField.snp.bottom)
            make.leading.trailing.equalTo(verificationCodeTextField)
            make.height.equalTo(1)
        }
        
        confirmButton.snp.remakeConstraints { make in
            make.centerY.equalTo(verificationCodeTextField)
            make.leading.equalTo(verificationCodeTextField.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.height.equalTo(verificationCodeTextField.snp.height)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.leading.equalTo(verificationCodeUnderlineView.snp.leading)
            make.top.equalTo(verificationCodeUnderlineView.snp.bottom)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // 전화번호의 길이가 11자인지 검사합니다.
        guard phoneNumber.count == 11 else {
            return false
        }
        
        // 전화번호는 숫자로만 이루어져야 합니다.
        let phoneNumberCharacterSet = CharacterSet.decimalDigits
        guard phoneNumber.rangeOfCharacter(from: phoneNumberCharacterSet.inverted) == nil else {
            return false
        }
        
        // 모든 규칙을 통과한 경우 유효한 전화번호로 간주합니다.
        return true
    }
    func requestVerificationCode(phoneNumber: String) {
        let parameters: [String: Any] = [
            "phoneNumber": phoneNumber,
            "verificationCode": "YourVerificationCodeHere"
        ]
        
        AF.request("https://api.yeonba.co.kr/users/join/phone-number", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Verification request successful with response: \(value)")
                    // 서버로부터의 응답에 따라 추가적인 처리를 수행할 수 있습니다.
                case .failure(let error):
                    print("Error requesting verification: \(error)")
                    // 에러 처리
                }
            }
    }
    
    func startTimer() {
        // 타이머가 이미 실행 중인 경우 먼저 중지시킵니다.
        stopTimer()
        
        // 1초마다 반복되는 타이머 생성
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            // 남은 시간 감소
            self.timeRemaining -= 1
            
            // 타이머가 종료되면 처리
            if self.timeRemaining <= 0 {
                self.stopTimer()
                // 여기에 타이머 종료 시 처리할 내용을 추가합니다.
                // 예: 시간이 종료되었음을 사용자에게 알림
            }
        }
    }
    
    // 타이머를 중지하는 함수
    func stopTimer() {
        timer?.invalidate() // 타이머 중지
        timer = nil
    }
    
    //MARK: -- Action
    //전송 버튼을 눌를 경우
    @objc func sendCodeButtonTapped() {
        guard let phoneNumber = phoneNumberTextField.text else {
            return
        }
        if isValidPhoneNumber(phoneNumber) {
            // 전화번호가 유효한 경우
            requestVerificationCode()
            // 타이머 시작
            startTimer()
        } else {
            // 전화번호가 유효하지 않은 경우, 사용자에게 알림 등을 표시할 수 있습니다.
            // 예: UIAlertController를 사용하여 경고창을 표시하거나, 적절한 방법으로 사용자에게 메시지를 전달합니다.
            print("전화번호는 11자리의 숫자여야 합니다.")
        }
    }
    
    @objc func confirmButtonTapped() {
        // TODO: 인증번호 유효성 검사 로직을 여기에 구현합니다.
        // 인증번호 유효성 검사 통과 후
        verificationSuccessful()
    }
    
    
    private func requestVerificationCode() {
        // 예시로, 성공했다고 가정하고 verificationCodeTextField를 활성화합니다.
        verificationCodeTextField.isHidden = false
        confirmButton.isHidden = false
    }
    
    private func verificationSuccessful() {
        // 인증 성공 시 '다음' 버튼을 활성화합니다.
        nextButton.isEnabled = true
        nextButton.backgroundColor = .systemBlue
    }
    
    
    @objc func nextButtonTapped() {
        let passwordVC = PasswordViewController()
        navigationController?.pushViewController(passwordVC, animated: true)
    }
}
