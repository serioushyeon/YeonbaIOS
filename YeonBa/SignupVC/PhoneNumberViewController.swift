import UIKit
import SnapKit
import Then

class PhoneNumberViewController: UIViewController {

    let instructionLabel = UILabel().then {
        $0.text = "전화번호를 입력해주세요."
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 24)
        $0.numberOfLines = 0
    }
    
    let instructionLabel2 = UILabel().then {
        $0.text = "가입여부에만 활용되며, 절대 노출되지 않아요."
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 16)
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
    }
    
    let sendCodeButton = UIButton().then {
        $0.setTitle("전송", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.backgroundColor = .systemGray
        $0.layer.cornerRadius = 10
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
        $0.backgroundColor = .systemGray
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    let nextButton = ActualGradientButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .systemGray
        $0.layer.cornerRadius = 25
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
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        instructionLabel2.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
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
        
        sendCodeButton.backgroundColor = .clear
        sendCodeButton.layer.borderWidth = 1
        sendCodeButton.layer.borderColor = UIColor.systemGray.cgColor
        sendCodeButton.snp.remakeConstraints { make in
            make.centerY.equalTo(phoneNumberTextField)
            make.leading.equalTo(phoneNumberTextField.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(70)
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
        
        confirmButton.backgroundColor = .clear
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = UIColor.systemGray.cgColor
        confirmButton.snp.remakeConstraints { make in
            make.centerY.equalTo(verificationCodeTextField)
            make.leading.equalTo(verificationCodeTextField.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(70)
            make.height.equalTo(verificationCodeTextField.snp.height)
        }

        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
    }

    @objc func sendCodeButtonTapped() {
        // TODO: 전화번호 유효성 검사와 인증번호 전송 로직을 여기에 구현합니다.
        // 전화번호 유효성 검사 통과 후
        requestVerificationCode()
    }
    
    @objc func confirmButtonTapped() {
        // TODO: 인증번호 유효성 검사 로직을 여기에 구현합니다.
        // 인증번호 유효성 검사 통과 후
        verificationSuccessful()
    }

    private func requestVerificationCode() {
        // 인증번호를 요청하는 로직 구현...
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
        // '다음' 버튼을 누를 때 호출되는 메서드
        // 다음 화면으로 이동하는 로직을 여기에 구현합니다.
        
        let passwordVC = PasswordViewController()
        navigationController?.pushViewController(passwordVC, animated: true)
    }
}
